From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 0/8] memcg: charge path cleanups
Date: Tue, 11 Mar 2014 21:28:26 -0400
Message-ID: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=Message-Id:Date:Subject:Cc:To:From; bh=+bL5PlZPzq6a/AbbRUMUpmAEy2/o8AegRX7gfQnAdDA=;
	b=hj5/WTVc0NWqtMT66ipqiUCw0Q+oa2TqeKJ4t3eLVxHfJV+GtuGN84ZDLu1LVoUxA8rvSWinPCzfxAj1crsQriKCJxmPMIB3vhbEIijh9DLAItwqGB3HSGndjsns1/Ay55eyTqeH+sJL91DiLv1Odgtfe7m0jUgrZBhVu0nINuw=;
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,

here are some cleanups and refactoring efforts of the memcg charge
path for 3.15 from Michal and me.

 mm/memcontrol.c | 319 +++++++++++++++++++-----------------------------------
 1 file changed, 112 insertions(+), 207 deletions(-)
