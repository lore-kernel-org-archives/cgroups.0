From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] memcg: make it work on sparse non-0-node systems
Date: Mon, 29 Apr 2019 14:11:51 +0200
Message-ID: <a8c032b3-a0be-1710-3ec3-cc3b0b1aaa67@suse.cz>
References: <359d98e6-044a-7686-8522-bdd2489e9456@suse.cz>
 <20190429105939.11962-1-jslaby@suse.cz>
 <20190429112916.GI21837@dhcp22.suse.cz>
 <465a4b50-490c-7978-ecb8-d122b655f868@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <465a4b50-490c-7978-ecb8-d122b655f868@suse.cz>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

On 29. 04. 19, 13:55, Jiri Slaby wrote:
> Well, I could have used first_node. But I am not sure, if the first
> POSSIBLE node is also ONLINE during boot?

Thinking about it, it does not matter, actually. Both first_node and
first_online are allocated and set up, no matter which one is ONLINE
node. So first_node should work as good as first_online_node.

thanks,
-- 
js
suse labs
