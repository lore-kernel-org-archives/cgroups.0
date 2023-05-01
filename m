From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 01/40] lib/string_helpers: Drop space in string_get_size's output
Date: Mon,  1 May 2023 09:54:11 -0700
Message-ID: <20230501165450.15352-2-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960110; x=1685552110;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tgVoyGNNM2CEwgGlnNhwRO5zW+BCSfKlhykn/JkHIoY=;
        b=2YKjiLNW+kfuA2PzlgEprNmYD56U2DvqAYUQT3SxKi2Wkcms/FURL1MvVV4lKJqj8O
         6/Ns7jrOtbP8ic5/FVYS4laNGQMz7H1sQUQlCcm/XRw/h77Gbtg2COyXGd2xvroS0fJn
         qwWPXD+NTjhYN8F2PIhFlV9xM7/YRbLeL8oWUbHvCo0bmT2YG7Au7XFXE7JF9tMEE+O2
         Razpx64/yqsX3p0ZTAuL1qwvem7fqbeaFnGoyPVJo12mzY/mv/yC7mdLiyEupHVMtu6T
         xYmQq3px4UJy+E+76my+C+5ib12oMdQjlgTcOmFRh/w96xFVezYHyxkBpY3bPmKf/8tt
         YK/Q==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

From: Kent Overstreet <kent.overstreet@linux.dev>

Previously, string_get_size() outputted a space between the number and
the units, i.e.
  9.88 MiB

This changes it to
  9.88MiB

which allows it to be parsed correctly by the 'sort -h' command.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: "Noralf Tr=C3=B8nnes" <noralf@tronnes.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 lib/string_helpers.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/string_helpers.c b/lib/string_helpers.c
index 230020a2e076..593b29fece32 100644
--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -126,8 +126,7 @@ void string_get_size(u64 size, u64 blk_size, const enum=
 string_size_units units,
 	else
 		unit =3D units_str[units][i];
=20
-	snprintf(buf, len, "%u%s %s", (u32)size,
-		 tmp, unit);
+	snprintf(buf, len, "%u%s%s", (u32)size, tmp, unit);
 }
 EXPORT_SYMBOL(string_get_size);
=20
--=20
2.40.1.495.gc816e09b53d-goog

