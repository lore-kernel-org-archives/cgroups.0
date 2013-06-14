From: Glauber Costa <glommer@gmail.com>
Subject: [PATCH v2 0/2] slightly rework memcg cache id determination
Date: Fri, 14 Jun 2013 14:04:34 -0400
Message-ID: <1371233076-936-1-git-send-email-glommer@openvz.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=ds+V0k2No3lT5PMrx64yWK/jAQhPdf+2ncu4z+jrPvk=;
        b=qS9rxIX8+oZ2JJyTgHVBIiKnwnLqGHdrjEgO3v5pN1CjGB28CF4H9FEL2ew4MNk7Nf
         WNpvREWa0/ceN2oxKQnYqjXmDSQckL6nYQZSeqY6W3uIXRKs4lv8BqzAgcRNoUuVRj9Z
         KzA+nOI+d/fybB5A7B1dilULwJRIkkojMEyjlcA7uGraXl/dl8tZ2iM4QeTRVcu+J3OI
         4GdP9nHD4fBvvGjd2OVIl6zyLylH6SuOHcvQOlHh8R9SLFSYr1D21aaMqMIlrh8uBvJ9
         RimIF9WW0KZVHhmDWTbrp/YFu7EZtuRsi7HlMiLfvaAznVK9Q6MxZ5KrvFxhrV4Q9eBu
         RB4g==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm <linux-mm@kvack.org>, cgroups <cgroups@vger.kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Glauber Costa <glommer@openvz.org>

Michal,

Let me know if this is more acceptable to you. I didn't take your suggestion of
having an id and idx functions, because I think this could potentially be even
more confusing: in the sense that people would need to wonder a bit what is the
difference between them.

Note please that we never use the id as an array index outside of memcg core.
So for memcg core, I have changed, in Patch 2, each direct use of idx as an
index to include a VM_BUG_ON in case we would get an invalid index.

For the other cases, I have consolidated a bit the usage pattern around
memcg_cache_id.  Now the tests are all pretty standardized.

Glauber Costa (2):
  memcg: make cache index determination more robust
  memcg: consolidate callers of memcg_cache_id

 mm/memcontrol.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

-- 
1.8.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
