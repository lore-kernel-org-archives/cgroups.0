From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 0/2] mm: memcg: 3.13 fixes
Date: Wed,  4 Dec 2013 17:45:12 -0500
Message-ID: <1386197114-5317-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=ibXmzhNMNemvbHH+K9PFC6amCUcrABN3mowOmYu7Brk=;
	b=mOP51/Hn2l6Bpy16F++7ACUWmgFNOcatoPD/M6IQNERJc4mcni9czIShSxX8OhV24FBpRdZmNXxlqrhooQiF9cYvByWrVO/iE/tIkYrewawKqPpM3y2JRpMN/ObWJgqfNxv/glYRxlIvPXw/q3f2AfipwMa/HEX1GZA/6uoHSbI=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

here are two memcg fixes for 3.13.

The race condition in #1 is really long standing AFAICS, I just tagged
stable and will backport and evaluate this for any tree that sends me
a notice.

#2 changes what happens during a charge attempt between a task
entering memcg OOM and actually executing the kill.  I had these
charges bypass the limit in the hope that this would expedite the
kill, but there is no real evidence for it and David was worried about
an unecessary breach of isolation.  This was introduced in 3.12.

 mm/memcontrol.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
