From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 00/10] docs: cgroup-v1: formatting improv for "Memory Resource Controller" doc
Date: Mon, 19 Dec 2022 11:21:59 +0700
Message-ID: <20221219042209.22898-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U/dEEVX13cf5N+hd3J7uA7Y2/NQepsAAVSk8729Qq40=;
        b=qFO7HG25w+cLED22tN8Huxazgyrk+kzJbcPjLeO6N5NIO87MAUVwX6Mumxf/9vIlzh
         +SYfE99b2GWxjvw+XvnIxmevcqKVbYVkJwRKvvepIVV4eWzKf9wEw+N2umVIZRO4JXBV
         ekPbMz+RLOENjk59Ctzt6ajDF4ya3KrNjAHvEJIPbD7d88ck1eOcPWWojDK8oQYLwEeG
         lq8QiVRcQPU9zlXHRVIsRlNveA6XFeHGCtp7y8RJzugbu2S5Vpxgtxzo0GpeE1l+3WDV
         vDrHp6LeT8Pi4lu3o3MPD/ixNr4yiRXnmlBF4q2vBQU2dEs/UVzFDkLwqOcTdpML+5qC
         eGbg==
X-Developer-Signature: v=1; a=openpgp-sha256; l=1307; i=bagasdotme@gmail.com; h=from:subject; bh=9tZWDHm18Fs9yM3gahlNr+8oWRyGbaFrmuTs8kx2K9Y=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnznz2bYXQ7luWTyI/JguFViRrree0P749+tHGCyfZ/H1fn l6hu6yhlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEzoQwMmypnO4aKnYoMvXzfpaNH5 nsvnkfjGxNmL9ZdUlKie/SozcZ/sqVX7ghs/N3p7WjUsRC2TXvBUrncGjOPObadH9F/ATTqZwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

"Memory Resource Controller" CGroup v1 documentation has been in reST
since 99c8b231ae6c6c ("docs: cgroup-v1: convert docs to ReST and rename to *.rst"). The current doc look is kinda ugly, so improve the formatting (only
htmldocs is tested).

The first patch is a fix for recently reported htmldocs warning, which can
be pickup separately from rest of the series.

Bagas Sanjaya (10):
  docs: cgroup-v1: extend underline of section 8
  docs: cgroup-v1: replace custom note constructs with appropriate
    admonition blocks
  docs: cgroup-v1: wrap remaining admonitions in admonition blocks
  docs: cgroup-v1: use code block for locking order schema
  docs: cgroup-v1: fix footnotes
  docs: cgroup-v1: move hierarchy of accounting caption
  docs: cgroup-v1: use bullet lists for list of stat file tables
  docs: cgroup-v1: use make swap extension subsections subsections
  docs: cgroup-v1: add internal cross-references
  docs: cgroup-v1: use numbered lists for user interface setup

 .../admin-guide/cgroup-v1/cgroups.rst         |   2 +
 .../admin-guide/cgroup-v1/memory.rst          | 290 ++++++++++--------
 2 files changed, 158 insertions(+), 134 deletions(-)


base-commit: fb94e0734a2aaf6fc11c92959efc640370df8d42
-- 
An old man doll... just what I always wanted! - Clara

