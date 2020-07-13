From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 0/2] mm, memcg: reclaim harder before high throttling
Date: Mon, 13 Jul 2020 12:42:13 +0100
Message-ID: <cover.1594640214.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=TvJxYzvOgzlC3BuPyn0KYnjcr7/OFk0QNHyHHZoEtGc=;
        b=rO39pjE0Wei+6nLZvaupuo2Ex4KuQD2qZ+3t6eBYQNcRJtvYdxAC8ONfkblcinlcJO
         CsVJ3UHvyqauDlk9iXmWwHEWUAv6UaIhcERBX4YfcmGPRVnAF+ubSh8IYXCZ3iIBZhvT
         yOhcnmyjlTvVR4JTTXRQsTb9HRlMgpn7BBmrM=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Changes since v1:

- Reclaim only SWAP_CLUSTER_MAX pages on reclaim retries, and add
  comment explaining why. Thanks Johannes for the suggestion.
- Unify into series.

Chris Down (2):
  mm, memcg: reclaim more aggressively before high allocator throttling
  mm, memcg: unify reclaim retry limits with page allocator

 mm/memcontrol.c | 53 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 12 deletions(-)

-- 
2.27.0

