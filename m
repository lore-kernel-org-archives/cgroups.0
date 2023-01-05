From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2 7/9] docs: cgroup-v1: make swap extension subsections subsections
Date: Thu,  5 Jan 2023 20:16:32 +0700
Message-ID: <20230105131633.553574-8-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGNG7VnZJT5NrQNN6BhNmvq0EdhUnj+GOmFvACaLTXk=;
        b=lsPMxNWnGO17JgyijK7xfpZgFbuz6KdZizssrHuAy+1vnSLEkHZ63zNwolvfA1EZEs
         Yopw5rWH6hUbO2tHXYC4UMNhlDh78F3wuO5FOS6QUvLG84FLyKpKHbp7hgUK0mrDE266
         XFK59lSLCDz2YVDChTwwU7qUKHhu1uIN5laO41h+2Xb5hv3qgLeG3wzzfnlc0bTq9PX3
         B9H6zlDTXgbwY9BgPwwxV0LscCEfKgt5D2hFe+ZZT8ELPkfmsPIC1zLGoCFfwT9ptYRJ
         OiI/zEhACIbeIQZj4gX3ZNOIZWwBHgLZd5nSmrNibY2Y9ohvzqWNBRiWXIYx71tYtErD
         dHeA==
In-Reply-To: <20230105131633.553574-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1657; i=bagasdotme@gmail.com; h=from:subject; bh=uE+t77fun6ccoXEmhoP8hbo16qhF0xOO2tCNjGXW6A8=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzm5YGvPgaJDfiTkV7UzLnq4MEK/bPdWvcsokjUbebY/v rmbK7ShlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEqp0Y/ulb/hKJai3vXfLFNSWXae H1vUlBd6u7eT2tliVyViYL5jP84arouyobqPV75r2/0RX/O3V5z9t+3Sd1Y83q6smtj7ZZcgEA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

Subsections text of swap extension section is marked up as bold text,
whereas making them proper subsection is more appropriate.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 162cc26dcddb25..0e583a6f783955 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -244,7 +244,8 @@ In this case, setting memsw.limit_in_bytes=3G will prevent bad use of swap.
 By using the memsw limit, you can avoid system OOM which can be caused by swap
 shortage.
 
-**why 'memory+swap' rather than swap**
+2.4.1 why 'memory+swap' rather than swap
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 The global LRU(kswapd) can swap out arbitrary pages. Swap-out means
 to move account from memory to swap...there is no change in usage of
@@ -252,7 +253,8 @@ memory+swap. In other words, when we want to limit the usage of swap without
 affecting global LRU, memory+swap limit is better than just limiting swap from
 an OS point of view.
 
-**What happens when a cgroup hits memory.memsw.limit_in_bytes**
+2.4.2. What happens when a cgroup hits memory.memsw.limit_in_bytes
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 When a cgroup hits memory.memsw.limit_in_bytes, it's useless to do swap-out
 in this cgroup. Then, swap-out will not be done by cgroup routine and file
-- 
An old man doll... just what I always wanted! - Clara

