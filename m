From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2 2/9] docs: cgroup-v1: wrap remaining admonitions in admonition blocks
Date: Thu,  5 Jan 2023 20:16:27 +0700
Message-ID: <20230105131633.553574-3-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUYjmNJNX3EIHXC0Kg1oUFxJ9a1dGF+07OElWAzi70E=;
        b=pEf0tlDI14cg718e2UjLbBPIw6gz58pcBgl/mZqJb17JoDKmf4ebY3uoHvhwaYGc4d
         8//GhUDyynq9lR7EUZ6Jb13SOAUrqpVKd3I8d21JPwfc6OPxpWpQ3e7FAmPPoc503j4S
         Saszua8tfPTYOLVLfysVYmuwwkXPJjRc8sW4V2nJr++VrhuhpD8By2lx30peHyeKkghC
         MUn4aOiX7owa3KzqTQvF1fQL88hv2v21axjD4RoOxUlymmV266wrh+fKvf7Pv32Z7vLr
         lKQwQgQpgQdJ/DCU0VBUNvyV70VCzFBQKoJebskRh4/uNFBWOhqX2wTM8loT+ohIZLAf
         yj3A==
In-Reply-To: <20230105131633.553574-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1148; i=bagasdotme@gmail.com; h=from:subject; bh=lVJicFMEl6ad4fCfED8HKHDv/aSeW7ylfz8qS3An+no=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzq4vNBYKCd3bmcV9+5uUy0z7o9MXVf7QviLr+cXonYRX St7jjlIWBjEuBlkxRZZJiXxNp3cZiVxoX+sIM4eVCWQIAxenAEzk9CKGf9b/N0rf1hF0ce5oufcnok N88nLxF9U6JlvWFldayGfc9WVkWGDful9O0+7A0yDvRIf/St5zCg7L64uXOU4pVkrT0bXgBgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

Wrap two other admonitions in appropriate blocks in order for readers to
pay more attention to block contents:

  * hint:: for editor's note
  * warning:: for move charges deprecation

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index d0d8c780cb6bd9..b0353c40639b7e 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -13,7 +13,7 @@ Memory Resource Controller
       memory controller in this document. Do not confuse memory controller
       used here with the memory controller that is used in hardware.
 
-(For editors) In this document:
+.. hint::
       When we mention a cgroup (cgroupfs's directory) with memory controller,
       we call it "memory cgroup". When you see git-log and source code, you'll
       see patch's title and function names tend to use "memcg".
-- 
An old man doll... just what I always wanted! - Clara

