From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2 RESEND] cgroup: cgroup_procs_next should increase
 position index
Date: Wed, 12 Feb 2020 17:00:22 -0500
Message-ID: <20200212220022.GG80993@mtj.thefacebook.com>
References: <20200128172737.GA21791@blackbody.suse.cz>
 <821bde4f-bdaf-994c-d864-a8a97d7d6b13@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J3XSJleCuaTuotjsG7Nz7OJ9sisD14+N/U/FPfy3Kas=;
        b=Rgj5oM2AgQOyAIVwpO9FUEqEuYh2rq1Qcs8tdtwXgmu7UV9lRMr8F0eS+J0E3hiIdh
         2qvJAUtnDeKSs1qjhoObSmsaPleyLyTXuxYhyHyMTqFdUN2s7MAGBDhNevco6a+Zcyqs
         wkNG9AlCj7a0IySqIPWa2YsnooUtLDnzKMCYO5xJdTNmkFKRrS2kTw2qoyYw1UasjufF
         PEYg9Lgu9hE/VbDESGvYwQGF/otYOgmHXc11u8Wwqq7A3vtHYH72vhiohqoJkxlPe2/8
         xo2aFXcZ2QMv2u+QuyeRbZ5xJisVT00t2sjQ/k1nGf1aDQQ5HoKGiN7D0OatjYC4pugh
         V/pA==
Content-Disposition: inline
In-Reply-To: <821bde4f-bdaf-994c-d864-a8a97d7d6b13-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Thu, Jan 30, 2020 at 01:34:59PM +0300, Vasily Averin wrote:
> If seq_file .next fuction does not change position index,
> read after some lseek can generate unexpected output:

Applied 1-2 to cgroup/for-5.6-fixes.

Thanks.

-- 
tejun
