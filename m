From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [patch v2 3/3] kernel, cpuset: remove exception for __GFP_THISNODE
Date: Mon, 02 Mar 2015 14:47:32 +0100
Message-ID: <54F469F4.1080805@suse.cz>
References: <alpine.DEB.2.10.1502251621010.10303@chino.kir.corp.google.com> <alpine.DEB.2.10.1502271415510.7225@chino.kir.corp.google.com> <alpine.DEB.2.10.1502271417270.7225@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1502271417270.7225@chino.kir.corp.google.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Pravin Shelar <pshelar@nicira.com>, Jarno Rajahalme <jrajahalme@nicira.com>, Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, dev@openvswitch.org

On 02/27/2015 11:17 PM, David Rientjes wrote:
> Nothing calls __cpuset_node_allowed() with __GFP_THISNODE set anymore, so
> remove the obscure comment about it and its special-case exception.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>
