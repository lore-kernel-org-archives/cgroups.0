From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Tue, 19 Dec 2017 13:41:07 -0800
Message-ID: <20171219214107.GR3919388@devbig577.frc2.facebook.com>
References: <20171219000131.149170-1-shakeelb@google.com>
 <20171219124908.GS2787@dhcp22.suse.cz>
 <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
 <20171219152444.GP3919388@devbig577.frc2.facebook.com>
 <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
 <20171219173354.GQ3919388@devbig577.frc2.facebook.com>
 <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4erIXUnqrK6JAWG//IjJJVaBj4cxfVKtubglKPxT0SM=;
        b=ITqLklpkhX4joS5SAYbnYqh6o0wJqfovcbV9OHQCAg1Ci9FtrN5883JfU0a3gyRfwe
         eOA+VyydB0I7LNIq4FuirxZpRYDcGV5bRNzsE4ts9ODG1NWqhzlNZZWMyKbppuKeGDr1
         dFAkRzqo6GCh23BmtjtyvYim1nDb/0VX/CWlutJ5De1oeCjXXBsgCfjHLMTRJ+90UbWl
         K0CzHPW+ZGdVyhPheAiQgHy5dollFmoqlqgLpJdm1HxdU3POEQspOciZ8FU862sFZv+N
         K+YD5wjUPKZzTs1vKXbzrxUBw9g4AYlwhR47PoB8kOgGpLjpNaRTLJ0K0K8gIkzaU6YY
         zc9w==
Content-Disposition: inline
In-Reply-To: <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

Hello,

On Tue, Dec 19, 2017 at 10:25:12AM -0800, Shakeel Butt wrote:
> Making the runtime environment, an invariant is very critical to make
> the management of a job easier whose instances run on different
> clusters across the world. Some clusters might have different type of
> swaps installed while some might not have one at all and the
> availability of the swap can be dynamic (i.e. swap medium outage).
> 
> So, if users want to run multiple instances of a job across multiple
> clusters, they should be able to specify the limits of their jobs
> irrespective of the knowledge of cluster. The best case would be they
> just submits their jobs without any config and the system figures out
> the right limit and enforce that. And to figure out the right limit
> and enforcing it, the consistent memory usage history and consistent
> memory limit enforcement is very critical.

I'm having a hard time extracting anything concrete from your
explanation on why memsw is required.  Can you please ELI5 with some
examples?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
