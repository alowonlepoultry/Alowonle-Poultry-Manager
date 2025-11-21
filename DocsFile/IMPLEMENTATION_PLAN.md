# Implementation Plan: Poultry Manager MVP

This document outlines the step-by-step plan to build the Poultry Manager app based on the PRD.

## Phase 1: Project Initialization & Architecture
**Goal:** Set up the foundation, routing, and state management structure.
1.  **Initialize Flutter Project:**
    -   Create project `poultry_manager`.
    -   Add dependencies (`flutter_riverpod`, `hive_ce`, `go_router`, `fl_chart`, etc.).
    -   Set up `analysis_options.yaml` (linting).
2.  **Folder Structure:**
    -   `lib/core/`: Constants, Theme, Utilities (Date formatters), Error handling.
    -   `lib/data/`: Hive Models (TypeAdapters), Local Data Sources (Boxes).
    -   `lib/features/`:
        -   `dashboard/`
        -   `inventory/`
        -   `pens/`
        -   `logs/`
        -   `reports/`
    -   `lib/main.dart`: App Entry point, ProviderScope, Router setup.
3.  **Navigation Setup (GoRouter):**
    -   Define routes: `/` (Dashboard), `/pens`, `/pens/add`, `/pens/:id`, `/inventory`, `/logs/add`, `/reports`.
    -   Implement a `ScaffoldWithNavBar` shell for bottom navigation.

## Phase 2: Local Database Layer (Hive)
**Goal:** Ensure data persistence works before building UI.
1.  **Define Models:**
    -   `Pen` (id, name, breed, initialCount, dateStarted).
    -   `InventoryItem` (id, name, currentBalance, lowStockThreshold).
    -   `DailyLog` (id, penId, date, mortality, feedGiven, feedTypeId, eggsCollected).
2.  **Generate Adapters:** Run `build_runner` to generate TypeAdapters.
3.  **Database Service:**
    -   Create a `StorageService` to handle opening/closing boxes.
    -   Create Providers: `pensBoxProvider`, `inventoryBoxProvider`, `logsBoxProvider`.

## Phase 3: Inventory Feature
**Goal:** Manage feed stock (crucial dependency for logging).
1.  **Logic/State:**
    -   `InventoryRepository`: methods for `addStock`, `createItem`, `updateThreshold`.
    -   `inventoryProvider`: Stream of inventory items.
2.  **UI:**
    -   `InventoryScreen`: List of items with current stock.
    -   `AddInventoryDialog`: Create new feed type.
    -   `StockUpdateDialog`: Add stock to existing item.

## Phase 4: Pen Management
**Goal:** Create and view flocks.
1.  **Logic/State:**
    -   `PenRepository`: methods for `addPen`, `getPen`.
    -   `pensProvider`: Stream of all pens.
2.  **UI:**
    -   `PenListScreen`: Cards showing name and basic status.
    -   `AddPenScreen`: Form validation.
    -   `PenDetailScreen`: Header with stats (will connect to logs later).

## Phase 5: Daily Logging (Core Feature)
**Goal:** The main action loop.
1.  **Logic/State:**
    -   `LogRepository`: `addLog(Log log)`.
    -   **Transaction Logic:**
        -   When saving a log:
            1.  Check `Inventory` balance for selected feed.
            2.  If `balance < feedGiven`, throw/show warning.
            3.  If confirmed, deduct from `Inventory` AND save `DailyLog`.
2.  **UI:**
    -   `AddLogScreen`:
        -   Dropdowns for Pen and Feed Type.
        -   Validation: Mortality <= Current Birds (requires fetching Pen data).
        -   Validation: Feed Stock check.

## Phase 6: Dashboard & Analytics
**Goal:** Visualize the data.
1.  **Logic/State:**
    -   `dashboardStatsProvider`: Calculates:
        -   Total Birds (Live).
        -   Today's Eggs.
        -   Low Stock Alerts (Filter inventory where balance < threshold).
    -   `productionTrendProvider`: Aggregates last 7 days eggs.
2.  **UI:**
    -   `DashboardScreen`:
        -   `AlertBanner` (Conditional).
        -   `StatCards`.
        -   `ProductionChart` (using `fl_chart`).

## Phase 7: Reports & Tools
1.  **FCR Calculator:** Simple standalone form (Input -> Output).
2.  **PDF Report:**
    -   Dependency: `pdf`, `printing`.
    -   Logic: Query logs by date range -> Generate PDF Layout -> Preview/Print.

## Phase 8: Polish & Release Preparation
1.  **Empty States:** Verify every list has a friendly empty widget.
2.  **Offline Testing:** Ensure no crashes in airplane mode (Hive is local, so this should be native).
3.  **Icons & Splash:** Set app icon and launch screen.

