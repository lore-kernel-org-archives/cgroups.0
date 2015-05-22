From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 0/3] memcg: mm_update_next_owner() cleanups
Date: Fri, 22 May 2015 20:22:51 +0200
Message-ID: <20150522182251.GE26770@redhat.com>
References: <20150519121321.GB6203@dhcp22.suse.cz> <20150519212754.GO24861@htj.duckdns.org> <20150520131044.GA28678@dhcp22.suse.cz> <20150520132158.GB28678@dhcp22.suse.cz> <20150520175302.GA7287@redhat.com> <20150520202221.GD14256@dhcp22.suse.cz> <20150521192716.GA21304@redhat.com> <20150522093639.GE5109@dhcp22.suse.cz> <20150522162900.GA8955@redhat.com> <20150522182054.GA26770@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150522182054.GA26770@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-mm@kvack.org

On 05/22, Oleg Nesterov wrote:
>
> On 05/22, Oleg Nesterov wrote:
> >
> > Oh. I think mm_update_next_owner() needs some cleanups. Perhaps I'll send
> > the patch today.
>
> At least something like this...
>
> Although I still think we can just remove this code. Plus this series
> was only compile tested, so please feel free to ignore.

Heh ;) sorry for noise.

Yes, please ignore, I just notice another email from you. Will reply
in a minute.

Oleg.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
