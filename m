From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v1 1/5] cgroup: net_prio: Mark local used function
 static
Date: Fri, 26 Oct 2012 03:41:45 -0400 (EDT)
Message-ID: <20121026.034145.1107343238754328094.davem@davemloft.net>
References: <1351174619-5096-1-git-send-email-wagi@monom.org>
	<1351174619-5096-2-git-send-email-wagi@monom.org>
	<20121025182858.GA15105@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20121025182858.GA15105@hmsreliant.think-freely.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: nhorman@tuxdriver.com
Cc: wagi@monom.org, netdev@vger.kernel.org, cgroups@vger.kernel.org, daniel.wagner@bmw-carit.de, john.r.fastabend@intel.com, lizefan@huawei.com, tj@kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Thu, 25 Oct 2012 14:28:58 -0400

> On Thu, Oct 25, 2012 at 04:16:55PM +0200, Daniel Wagner wrote:
>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>> 
>> net_prio_attach() is only access via cgroup_subsys callbacks,
>> therefore we can reduce the visibility of this function.
>> 
>> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
 ...
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Applied.
