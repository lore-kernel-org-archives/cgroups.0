From: David Rientjes <rientjes@google.com>
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
Date: Thu, 5 Jun 2014 14:01:02 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1406051358210.18119@chino.kir.corp.google.com>
References: <1401976841-3899-1-git-send-email-richard@nod.at> <1401976841-3899-2-git-send-email-richard@nod.at> <20140605150025.GB15939@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=I4rHP3Noip/o1E3kvb8xEuSLD433Qpp5EucC45vXW5s=;
        b=i6yyLOoiKzXi4ZQkvm35+UKpzSmlLi0IBcfUjV4FUkWcQZTb2EjhY/1jocKUiOUSbu
         K0rnhgwdk6zx/b44Wj6ffrZc3j/chrfOCKZ9zLyQh7P8RJzz3YEz3JBw3EvntWaumCYT
         7cz6uh6h25nmbvRWDXpAIFsSD+AggxJuGexPyOaqm8c4JeSFGm7lqdGY3huStM11jpMz
         V+LGMs4ivruyulo/aPVu8TLeb4UTmgVYt14r0JPrhtns8VG94lsnzonc+bxDEFCG9Vvw
         /WpS2Yv7Xd8uCb9ofIzSEzFfz6CUfrEfwyoX/UpKBF3elq2yhodhyzQ920HZBbdsPu4T
         PwNw==
In-Reply-To: <20140605150025.GB15939@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Richard Weinberger <richard@nod.at>, hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org, handai.szj@taobao.com, oleg@redhat.com, rusty@rustcorp.com.au, kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, 5 Jun 2014, Michal Hocko wrote:

> If we are printing too much then OK, let's remove those parts which are
> not that useful but hiding information which tells us more about the oom
> decision doesn't sound right to me.
> 

Memcg oom killer printing is controlled mostly by 
mem_cgroup_print_oom_info(), I don't see anything in the generic oom 
killer that should be removed and that I have not used even for memcg ooms 
in the past.

Perhaps there could be a case made for suppressing some of the 
hierarchical stats from being printed for memcg ooms and controlled by 
another memcg knob, but it doesn't sound vital.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
