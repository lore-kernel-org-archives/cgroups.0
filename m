From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Wed, 27 Apr 2022 15:51:55 -0400
Message-ID: <Ymme244DTWy/tAli@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <20220427113654.ef8f543d7ba279952deff6f7@linux-foundation.org>
 <YmmRFOXJsjLj4a7T@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5hVT2KZy0tNO5QjzJ5BALuuraIswglFaGXimoEvq+80=;
        b=RoLeBSaeDEDxPoktV5qrOLc4/I2Dx+LTpNZ7Wj6fyQ77YMNwSeXgLPRJ1qSONbpqLR
         mHqNHPCRGKYe4R+86xtlO2LmdTXr+KGN3o2tP5wf1HtVfe2yfZhPfgKQ/S0pSXjGeWkc
         mxQ86Ev3GYvi7pRNES2AeprnQeaQfkrJsRuJwSjC6LRlRdwc3/TvxRjyMO+O/MRok5Px
         FhRWQcQ5QwoUtjRBdLtHkOqa6ia+JwES89j3PzlUKwIvB9YocPRIFt9yXcpXWS0SHeAa
         OYC3h+xkoY6Sima1XoDlvOxF49Whe+96OBjV3uqLt3BX1y19vbvUsaastqGEdSSxG0RR
         66Pg==
Content-Disposition: inline
In-Reply-To: <YmmRFOXJsjLj4a7T@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Seth Jennings <sjenning@redhat.com>, Dan Streetman <ddstreet@ieee.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Apr 27, 2022 at 02:53:10PM -0400, Johannes Weiner wrote:
> [...] and a delta fixlet for 4/5.

From 35851ad3ddbf30122d755bdf8abea6dc188492a2 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 27 Apr 2022 15:44:23 -0400
Subject: [PATCH 6/7] mm: zswap: add basic meminfo and vmstat coverage fix

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/filesystems/proc.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 736ed384750c..8b5a94cfa722 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -964,6 +964,8 @@ Example output. You may not have all of these fields.
     Mlocked:               0 kB
     SwapTotal:             0 kB
     SwapFree:              0 kB
+    Zswap:              1904 kB
+    Zswapped:           7792 kB
     Dirty:                12 kB
     Writeback:             0 kB
     AnonPages:       4654780 kB
@@ -1055,6 +1057,10 @@ SwapTotal
 SwapFree
               Memory which has been evicted from RAM, and is temporarily
               on the disk
+Zswap
+              Memory consumed by the zswap backend (compressed size)
+Zswapped
+              Amount of anonymous memory stored in zswap (original size)
 Dirty
               Memory which is waiting to get written back to the disk
 Writeback
-- 
2.35.3

