From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: rstat: use same convention to assign
 cgroup_base_stat
Date: Wed, 12 Jan 2022 09:55:44 -1000
Message-ID: <Yd8yQFx/cOBGd6+N@slm.duckdns.org>
References: <20220108003817.6619-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pTkXuSKZdEidYDtUquppnkS8GPvDaeca2bpqBFg2VUk=;
        b=aVDCcfyGG6eZ7fQRZwIpKvAV3p4XQAIsCDHU4V8R68gVluTPXLyO4TF+tuwhm7XNxH
         2VFN9RxstCr5amo4nthsCVIpWzI31OwDeQN2LuYI4sWHzWcRLMB7vii4FIcLCxFHvuk1
         hQ7tW6OYVeXC6Mkku3+HVMdiL4OicoRI+GOcEe8uOTotfiLnVvGoiJ7mL0/n/Ya0Yqv7
         NfCSAd4pxzo1OW1rtcHHA87G7eCWLKSBrG/jHsP4/JaH4No9utBcUP7RryQqI8z3hg/V
         PUzZYlGbJLCwksdC5V2bXkWcbjX0AEAL/vErnFXE/LmN/wkCJmwpcfVzJIprU1iydK1r
         oKXw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220108003817.6619-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jan 08, 2022 at 12:38:16AM +0000, Wei Yang wrote:
> In function cgroup_base_stat_flush(), we update cgroup_base_stat by
> getting rstatc->bstat and adjust delta to related fields.
> 
> There are two convention to assign cgroup_base_stat in this function:
> 
>   * rstat2 = rstat1
>   * rstat2.cputime = rstat1.cputime
> 
> The second convention may make audience think just field "cputime" is
> updated, while cputime is the only field in cgroup_base_stat.
> 
> Let's use the same convention to eliminate this confusion.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied 1-2 to cgroup/for-5.18.

Thanks.

-- 
tejun
