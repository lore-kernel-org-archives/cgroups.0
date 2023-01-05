From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2 3/9] docs: cgroup-v1: use code block for locking order schema
Date: Thu,  5 Jan 2023 20:16:28 +0700
Message-ID: <20230105131633.553574-4-bagasdotme@gmail.com>
References: <20230105131633.553574-1-bagasdotme@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHKqH/mTeMAtJX+k1fwhOFwTW56tZzYBJVqR/bzkhlc=;
        b=XkW/T1soWfm4Rl1XX1uhjbNQfx1mx3n00vAID2EM9vtxWbYXinFO4hH0F/Sh76u8Nt
         T+gnK2msfrDFO1KmUccj24rF4UB8vifHeM6vVJGG4BqzWmkF5LR+KlioizvkKNFhtzGI
         DqZ08ByEgPPDNotBdzpS9VmCEyShtWZsvx3n8EAJPOHu1HX5kpNBORHmuWbj2c2tqTYV
         kKkA+xB6Fxx4Jc5iZgdCkvewR5ElvC1Q8mCbRjR5m0aVPDHOhmprl5Z6bpMJhV7aZOd2
         jqwuT8bQYA/2qPzKPL/nYTtz+E24L3VfdAWrshv08AHCMMHGZLUBryatFJX7kP89y92r
         Wa8g==
In-Reply-To: <20230105131633.553574-1-bagasdotme@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=903; i=bagasdotme@gmail.com; h=from:subject; bh=IgqigKn9DkjPklU4lRTNbnqTt63GfYY/akiSBYrKIlo=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDMnbzq4XDnK5Z2Dspp/XK6O/hDH/vy9jfrHcT7XO5Wcey2i5 SQp3lLIwiHExyIopskxK5Gs6vctI5EL7WkeYOaxMIEMYuDgFYCICVQz/a/lu5hjddea89ev3r8tRkp XRb02+MnYu/XFlWaNkJntyKyPDAc1vbdt6LNecrSx/q+j+h/XJHfs98c6Fk0yPFO7av6OBHQA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux CGroups <cgroups@vger.kernel.org>, Linux Documentation <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Bagas Sanjaya <bagasdotme@gmail.com>

The locking order schema is a figure (like diagram), which should have
been formatted with literal code block for consistency with other
figures.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index b0353c40639b7e..2b807fc128c662 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -287,7 +287,7 @@ When oom event notifier is registered, event will be delivered.
 2.6 Locking
 -----------
 
-Lock order is as follows:
+Lock order is as follows::
 
   Page lock (PG_locked bit of page->flags)
     mm->page_table_lock or split pte_lock
-- 
An old man doll... just what I always wanted! - Clara

