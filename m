From: Marco Ballesio <balejs-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup-v1: freezer: optionally killable freezer
Date: Fri, 28 Feb 2020 16:51:31 -0800
Message-ID: <20200229005131.GB9813@google.com>
References: <20200219183231.50985-1-balejs@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M4tgEyFArklK0C2NkHJ4Ev1DbekboBTuLVXflJ8Bdmg=;
        b=YEZrilU5Emz9Z8Ec+wHK4LiI7fQQzdfCcue2M/IsGBDlntu9mx1MWRLDNRF2DkbyzK
         R2lwOWZhgB6mzNpT1Pu/aYGOixkKd67bWXduwxC7akBPX2iYuMwBeOQ5JBnJ3PoP/sm+
         fwHlgE5NWc/QcaNpgQ1v36FCjFUNaQ0QzZjXLhJBB7HSyakmk/gogoPqwcbqcHALKGWF
         LEwHUDu3Vt5k84kgM8atzhoarq3m2Hp+ubtvEsIOjJSEjTqa8HV47MN06DuHfs+WThz5
         AS+PNvVOGiAiXvalk95ELB6qY6CzHUNlqNZ8cCZ8Kyzz7tO0GspqtRYJOBiBc4omlRU0
         Jamg==
Content-Disposition: inline
In-Reply-To: <20200219183231.50985-1-balejs-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, minchan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hi all,

did anyone have time to look into my proposal and, in case, are there
any suggestions, ideas or comments about it?

Marco
