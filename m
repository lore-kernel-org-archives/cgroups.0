From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup: limit cgroup psi file writes to processes
 with CAP_SYS_RESOURCE
Date: Wed, 1 Mar 2023 19:35:25 +0100
Message-ID: <Y/+a7fczvsVe2lPP@dhcp22.suse.cz>
References: <20230301014651.1370939-1-surenb@google.com>
 <Y/8fNrNm1B2h/MTb@dhcp22.suse.cz>
 <CAJuCfpERczW1YhEW0fN3p2zrdDj-Ec_pCONH6SQVEwTj0BHYMw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677695726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wf0mD7k3wd9pu1O3LZesHDQH1X0cWEqYTsQRgJAz/JI=;
        b=L6vDbXZpy0lNSzxUMms4I0wHVTM6awFbslQl43mrBFRtHAdGVwdgDOXZBmZfbDLIWT0uF/
        ogNoBc6TqAHVS8pw8Cs4WPthRjkE8V2MB0rKjnxTIbMaraLXGeeEAURWjStIXctM8F8BiS
        M3Kcgdt1zp+f5/ONAGx9TSOwAM3K16A=
Content-Disposition: inline
In-Reply-To: <CAJuCfpERczW1YhEW0fN3p2zrdDj-Ec_pCONH6SQVEwTj0BHYMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, johunt-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, quic_sudaraja-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 01-03-23 10:05:36, Suren Baghdasaryan wrote:
[...]
> Yes but hopefully my argument about keeping this and min period
> patches separate is reasonable?

I am not questioning that. The practical advantage to squash the two
changes is that in case of the CAP_SYS_RESOURCE you do not have to
explicitly think about reverting the min constrain as well. I do not
think reverting one without the other is good.

-- 
Michal Hocko
SUSE Labs
