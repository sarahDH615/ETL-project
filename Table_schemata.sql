-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "country" (
    "Country" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    CONSTRAINT "pk_country" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "vaccinations" (
    "Country" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "vaccination_date" date   NOT NULL,
    "total_vaccinations" int   NOT NULL,
    "avg_daily_vaccinations" float   NOT NULL,
    CONSTRAINT "pk_vaccinations" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "travel_restrictions" (
    "Country" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "Quarantine_type" VARCHAR   NOT NULL,
    "Quarantine_start_date" date   NOT NULL,
    CONSTRAINT "pk_travel_restrictions" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "full_closures" (
    "Policy_id" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "Policy_type" VARCHAR   NOT NULL,
    "Policy_subtype" VARCHAR   NOT NULL,
    "Policy_start_date" date   NOT NULL,
    "Citizen_exceptions" int   NOT NULL,
    "Citizen_exceptions_info" VARCHAR   NOT NULL,
    "Country_exceptions" int   NOT NULL,
    "Country_exceptions_info" VARCHAR   NOT NULL,
    "Work_exceptions" int   NOT NULL,
    CONSTRAINT "pk_full_closures" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "no_closures" (
    "Policy_id" VARCHAR   NOT NULL,
    "Country" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "Policy_type" VARCHAR   NOT NULL,
    "Policy_subtype" VARCHAR   NOT NULL,
    CONSTRAINT "pk_no_closures" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "partial_borders" (
    "Policy_id" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "Policy_type" VARCHAR   NOT NULL,
    "Policy_subtype" VARCHAR   NOT NULL,
    "Policy_start_date" date   NOT NULL,
    "Air_ban" int   NOT NULL,
    "Air_ban_type" VARCHAR   NOT NULL,
    "Air_ban_info" VARCHAR   NOT NULL,
    "Land_ban" int   NOT NULL,
    "Land_ban_type" VARCHAR   NOT NULL,
    "Land_ban_info" VARCHAR   NOT NULL,
    "Sea_ban" int   NOT NULL,
    "Sea_ban_type" VARCHAR   NOT NULL,
    "Sea_ban_info" VARCHAR   NOT NULL,
    CONSTRAINT "pk_partial_borders" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "partial_citizenship" (
    "Policy_id" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "Policy_type" VARCHAR   NOT NULL,
    "Policy_subtype" VARCHAR   NOT NULL,
    "Policy_start_date" date   NOT NULL,
    "Citizen_ban_info" VARCHAR   NOT NULL,
    CONSTRAINT "pk_partial_citizenship" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "partial_history" (
    "Policy_id" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "Policy_type" VARCHAR   NOT NULL,
    "Policy_subtype" VARCHAR   NOT NULL,
    "Policy_start_date" date   NOT NULL,
    "Travel_history_ban_info" VARCHAR   NOT NULL,
    CONSTRAINT "pk_partial_history" PRIMARY KEY (
        "Country_id"
     )
);

CREATE TABLE "partial_visa" (
    "Policy_id" VARCHAR   NOT NULL,
    "Country_id" VARCHAR   NOT NULL,
    "Policy_type" VARCHAR   NOT NULL,
    "Policy_subtype" VARCHAR   NOT NULL,
    "Policy_start_date" date   NOT NULL,
    "Visa_ban_list" VARCHAR   NOT NULL,
    "Visa_ban_info" VARCHAR   NOT NULL,
    CONSTRAINT "pk_partial_visa" PRIMARY KEY (
        "Country_id"
     )
);

ALTER TABLE "vaccinations" ADD CONSTRAINT "fk_vaccinations_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

ALTER TABLE "travel_restrictions" ADD CONSTRAINT "fk_travel_restrictions_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

ALTER TABLE "full_closures" ADD CONSTRAINT "fk_full_closures_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

ALTER TABLE "no_closures" ADD CONSTRAINT "fk_no_closures_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

ALTER TABLE "partial_borders" ADD CONSTRAINT "fk_partial_borders_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

ALTER TABLE "partial_citizenship" ADD CONSTRAINT "fk_partial_citizenship_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

ALTER TABLE "partial_history" ADD CONSTRAINT "fk_partial_history_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

ALTER TABLE "partial_visa" ADD CONSTRAINT "fk_partial_visa_Country_id" FOREIGN KEY("Country_id")
REFERENCES "country" ("Country_id");

