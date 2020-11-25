From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] kernel: cgroup: Mundane spelling fixes throughout the
 file
Date: Wed, 25 Nov 2020 07:56:32 -0500
Message-ID: <X75UgCWXJjplQ8Kw@mtj.duckdns.org>
References: <20201109103111.10078-1-unixbhaskar@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nNpoxskH44KK9KKuJ0pwAXxPc7WlonO/AVDvFJYaTko=;
        b=kyfFznwFpssDqWqK1A5JgwNdKa6yVAJ+mBMjofSKBvAU6ZKKWBZuSJ0jfcPOPmtq84
         bbVFCNJFKwgSFr4M2mOFguiLUh8MU2O2p/9mzOXo/tV/eNITnU3Pi1IgDicVfurnklB5
         rzY7zCceW9oaxIyptlaB0JUYsVjtokvbXWtVmXI655as7UOlm/JDxTDSGHLSuwyNZpsK
         y999e+tUAx20Xyu0x87WO6lBSlCXyTJ9duWU+MIxytl5ieQNkEljo5fHxQoS3JGPKABG
         Z0ddyatzmmp6zwty6MFjaGnIEoJT64QuOxadPHVr1nrH3bAgQAUJE4uqbViTlJxhqDG/
         Ievg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20201109103111.10078-1-unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 09, 2020 at 04:01:11PM +0530, Bhaskar Chowdhury wrote:
> Few spelling fixes throughout the file.
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-5.10-fixes.

Thanks.

-- 
tejun
