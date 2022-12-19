From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 08/10] docs: cgroup-v1: use make swap extension subsections subsections
Date: Mon, 19 Dec 2022 11:22:07 +0700
Message-ID: <20221219042209.22898-9-bagasdotme@gmail.com>
References: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agWt8CECL43NEhVRFwvhtAXySMNGigcHHGw9DmNksyg=;
        b=Rw+DM6QWhhdQXktWp+em/fBiFTj3BUilx3MP8RgeQvvsMgLuECpixEMst4FxDtn7zH
         rAtjr2VM4z0g7bvXq3KMTUQq427rHE6DpnzawpIYLHC4ZJe5B2U5vgtq/CW3nPXjtUXL
         EOTbYjZFPwUdqOlRePgXbAKfKz3l/dBEmZ/BsZAW7kFA+JnMNfrmriDf/smpetfVAs8V
         zlEYA+1aASqKs5fLj9Ca+PsuWMPAqfGTOCRjtX4FPTomYaN9JIrxcQ83tuhIlGF3dTo6
         tPX6UhACp5qTOwk+LxN3dvDkAeg+v22HECunwHxAfPX9gvjE+loAvHbiB0LNKPyfzp2b
         PG0Q==
In-Reply-To: <20221219042209.22898-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1657; i=bagasdotme@gmail.com; h=from:subject; bh=YB2axwGgINIOaNnBOhZC/NJ3W2+BU7qyWgI/kX2Gj+s=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnzn33I21Y795n3xfn/orzeP5p9r4RP8LZ3u0nrvSUhWSsM Gs4s7ihlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEHv5jZNj57tBtd/9bL4qZdyzn+b l3XeqJ8pQY9pMtkqu/q8zcUvyfkeF0rtX/9u2rLSbq3bjgea+r+adr3/YLwY3svLk39z+RXsQNAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

Subsections text of swap extension section is marked up as bold text,
whereas making them proper subsection is more appropriate.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 01104b459b4cbd..863e0f17ca0067 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -246,7 +246,8 @@ In this case, setting memsw.limit_in_bytes=3G will prevent bad use of swap.
 By using the memsw limit, you can avoid system OOM which can be caused by swap
 shortage.
 
-**why 'memory+swap' rather than swap**
+2.4.1 why 'memory+swap' rather than swap
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
 to move account from memory to swap...there is no change in usage of
@@ -254,7 +255,8 @@ memory+swap. In other words, when we want to limit the usage of swap without
 affecting global LRU, memory+swap limit is better than just limiting swap from
 an OS point of view.
 
-**What happens when a cgroup hits memory.memsw.limit_in_bytes**
+2.4.2. What happens when a cgroup hits memory.memsw.limit_in_bytes
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 When a cgroup hits memory.memsw.limit_in_bytes, it's useless to do swap-out
 in this cgroup. Then, swap-out will not be done by cgroup routine and file
-- 
An old man doll... just what I always wanted! - Clara

