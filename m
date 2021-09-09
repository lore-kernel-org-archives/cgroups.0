From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] misc_cgroup: introduce misc.failcnt for V1
Date: Thu, 9 Sep 2021 16:37:10 +0200
Message-ID: <20210909143709.GA14603@blackbody.suse.cz>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <c4e091c8c0208554b97f751ae80a093f55f19883.1631077837.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631198231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B13u36Po4th2PuCEKGfMkrGfL3GxX63/1jwqx05ECVY=;
        b=rzmaYDhYG5qnwQA/AoM96BOvbbRiPT5ow5w4NWsIMzyC/qCkdSV04NKUjqShHai0jwl5Lu
        P0p7dna95aJJtXGORVvI/Mm6X7gp6dVNTcpPs86fJmhxNXO356fn0MEROIaHBgkuWAFYIN
        RMKpLOWT6ngoKabiOmsB2f1GUB5Rd+4=
Content-Disposition: inline
In-Reply-To: <c4e091c8c0208554b97f751ae80a093f55f19883.1631077837.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Sep 08, 2021 at 01:24:35PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> introduce misc.failcnt for cgroup v1 to make it easier for us to
> understand the pressure of resources.

As argued in the patch 1/3, I'd drop this change completely.

Thanks,
Michal
