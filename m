From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: avoid false positive gcc-6 warning
Date: Wed, 16 Mar 2016 13:33:09 -0700
Message-ID: <20160316203309.GF21104@mtj.duckdns.org>
References: <1457997681-2011105-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g3+JDpA5mMiXUyMe6Cpn5wXBr1Io8Hj3g895UWSzNV4=;
        b=rR3Q4j7GZN1CGSfjU/BufigF97SWGVWVmEO/5Vb/RvilfDQvX5AWfS2Fs9GYRz5Jas
         GKf7kAV1zFlD2w8bcjsEWjjyQD6rYKXuzvz9uwR03ni0BGga0mi2C0aIesNVUclMvpJ8
         1yk/ok52Gt/+vWCu8E4H6giWyA9s0Xjf0h/1/okAuMbjGhOeigtJYSv9P685qOrsVmea
         ChVwTuJxe3E8sD8+pP7rCM7100x6luf62AGNdvMtMlVmrkPZ7TzIZ8c+7VBmN2hLNUlf
         agVB51a0QymzD0f/N+RsRFAILIyt/g6N+vyqu1UqZIXV0UiFR3553mzNIAzG9T94EN2u
         IWmA==
Content-Disposition: inline
In-Reply-To: <1457997681-2011105-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 15, 2016 at 12:21:06AM +0100, Arnd Bergmann wrote:
> When all subsystems are disabled, gcc notices that cgroup_subsys_enabled_key
> is a zero-length array and that any access to it must be out of bounds:
> 
> In file included from ../include/linux/cgroup.h:19:0,
>                  from ../kernel/cgroup.c:31:
> ../kernel/cgroup.c: In function 'cgroup_add_cftypes':
> ../kernel/cgroup.c:261:53: error: array subscript is above array bounds [-Werror=array-bounds]
>   return static_key_enabled(cgroup_subsys_enabled_key[ssid]);
>                             ~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
> ../include/linux/jump_label.h:271:40: note: in definition of macro 'static_key_enabled'
>   static_key_count((struct static_key *)x) > 0;    \
>                                         ^
> 
> We should never call the function in this particular case, so this is
> not a bug. In order to silence the warning, this adds an explicit check
> for the CGROUP_SUBSYS_COUNT==0 case.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Applied to cgroup/for-4.6.

Thanks.

-- 
tejun
