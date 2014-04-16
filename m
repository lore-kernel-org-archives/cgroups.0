From: Zhan Jianyu <nasa4836@gmail.com>
Subject: Re: [PATCH] mm/memcontrol.c: make mem_cgroup_read_stat() read all
 interested stat item in one go
Date: Wed, 16 Apr 2014 23:22:51 +0800
Message-ID: <CAHz2CGXiRnBuza6ByvuDZpuxB4sP3wDBZ2OiLTACEX7ZMAuvXw@mail.gmail.com>
References: <1397149868-30401-1-git-send-email-nasa4836@gmail.com> <20140416092245.GD12866@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=6YsQ3vtAHm5a0srvDYDbR++URK7FPrroS89NwSl7Zl8=;
        b=lwIgD40VUF9VdFF87nrm/J8PPWXL1mdfuN6nsIZ1gumzm05OR9GNTJGEthndtpbitW
         Dv7g/L0o5Qj0IcXqT1f54jqxC1LHV4Xn7RCXIrjCcuyoQoJhPAIUWt2rxCRXNBPc3teq
         dRZFZXFaYkr8dIn9FHNzoTZoQLsNA1C+OxzmPSl8GfUaaKRwPb+oGWz4mvuFrv+1hXXh
         oVhVJJ/8u2riea2aOZYAIVYF8Bky439Dal3P+x5bVYH1oSnUtHS1lZHM/iO13WwTq0o8
         Ujh76LH1/1PekVyFIDs/vwWsD67TjMDhFpAsARX6TnLUyvGcN9fH1m2QBlPYbyBJ5+Hm
         /EkQ==
In-Reply-To: <20140416092245.GD12866@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>, kamezawa.hiroyu@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, Apr 16, 2014 at 5:22 PM, Michal Hocko <mhocko@suse.cz> wrote:
> cannot say I like the new code much more than the previous one and
> I've never seen the old one being a bottleneck. So I am not entirely
> fond of optimization without a good reason. (Hint, if you are optimizing
> something always show us numbers which support the optimization)

Hmm, actually I now have no workload to support this optimizaton, I will
refine patch if I have one.  Thanks for all your comments.

Thanks,
Jianyu Zhan

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
