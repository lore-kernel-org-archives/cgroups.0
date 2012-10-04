From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 0/2] memcg fixups that fell through cracks in 3.5
Date: Thu,  4 Oct 2012 14:09:15 -0400
Message-ID: <1349374157-20604-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,

an older version of "mm: memcg: count pte references from every member
of the reclaimed hierarchy" patch made it into the 3.5
(c3ac9a8ade65ccbfd145fbff895ae8d8d62d09b0) by accident and I didn't
notice until just now.  #1 is a fixup on top, tagged for 3.5-stable.

#2 is a cleanup you requested but probably missed as it was attached
to a mail buried in the thread.  For 3.6.

Patches against mm.git.
