From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm, memcg: add a helper function to check may oom
 condition
Date: Mon, 9 Sep 2013 23:34:10 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1309092333590.20625@chino.kir.corp.google.com>
References: <522E74DD.5030706@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=Szw94TG5Tilj3f6awqhbWsMQDyD58LscF09ZuIIGQC8=;
        b=UeoumTAxn0XOLFCXySKSakn9f/H4Pjj2g9IFGlZXl/mx7YreABbRPUjKBZXgE/q8Kd
         5YPR/Qg0QNmbK5ZXczh+lcV3qox84A3C2qfkT9WQSO+U6RDjU0NO0p9yvK+mFxbElA6x
         jgX7ED/zNgVVsI2uh0bpBkRccD4mTqoao46dHXezBW6jhT994VU3oPH74Z5cih1mPMDr
         1lUeR/7eTxKquVfH6Fld8zo5lTB3OdVTS4KQswla3r/o7keTugMh02oGhq9S/nbcYKG/
         GXb4xbUVnCxgVxABXrz3QIiqlrBQ5QzX4AF6JPw7wr7DRUu153kQZb1y2Yzn8IRQwDmZ
         EKrA==
In-Reply-To: <522E74DD.5030706-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Tue, 10 Sep 2013, Qiang Huang wrote:

> Use helper function to check if we need to deal with oom condition.
> 
> v2:
> Change the function name to oom_gfp_allowed() as suggested by
> David Rientjes.
> 
> Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
