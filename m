From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] cgroup: get rid of populate for memcg
Date: Mon, 9 Apr 2012 15:42:46 -0700
Message-ID: <20120409224246.GA11614@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1334010994-23301-1-git-send-email-glommer@parallels.com>
 <1334010994-23301-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ttiEeSoBXywly+qeB7pfXjS9UFCpa8iaQyyTSzSRrA8=;
        b=xft1Qs1h5DY0Ac8LcJKI6NNr5TWOjhR1eljpG45jD9D8scHhDrzQ0L78pWNV2S4NBy
         jZMhWgwLFpoYcvzNYHj9Y1IFq4S6Vrm/I052tIhNhfGvy20HVSpsKuYl5m0BBl8N4fNB
         8L+cPC/nuEOhE6gtfBoEJzbv3uGesd0MHxO+ZaCVa2xpV01X0CJmDXksUwgtgKoSYemq
         jm4Z0bCInjsWs0n/U2qq9Rt4oNRdu8oJrQliQ61CW3oeBNHAJ3vyQMI+bLH5xJUYLKgd
         GGDIijzurPZ+ovCrjQBS7jbMYD1zWqY6h3Hjrwsjax9eRQhCX3D0Lixd9g5kGHxc0i9w
         aOwA==
Content-Disposition: inline
In-Reply-To: <1334010994-23301-3-git-send-email-glommer@parallels.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: netdev@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>

On Mon, Apr 09, 2012 at 07:36:34PM -0300, Glauber Costa wrote:
> The last man standing justifying the need for populate() is the
> sock memcg initialization functions. Now that we are able to pass
> a struct mem_cgroup instead of a struct cgroup to the socket
> initialization, there is nothing that stops us from initializing
> everything in create().
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Li Zefan <lizefan@huawei.com>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Michal Hocko <mhocko@suse.cz>

Will apply once memcg maintainers ack.

Thanks.

-- 
tejun
