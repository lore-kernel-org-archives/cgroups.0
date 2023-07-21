From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] docs: cgroup-v1: fix typo
Date: Fri, 21 Jul 2023 08:11:53 -1000
Message-ID: <ZLrKaYfn1qoWm5XM@slm.duckdns.org>
References: <20230721054938.1666475-1-xiongwei.song@windriver.com>
 <20230721054938.1666475-2-xiongwei.song@windriver.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689963115; x=1690567915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GRtzlaHKzDk5tTi7aUgo8xmfyZYu4TD/4asfXW62u9M=;
        b=KG4z0SDNckHDGHzSeIhkND6qLoO8j5teBq6VpviRqg16Aj72e032nyb3O5B1pcvnIe
         WQ/o2T8nisvb9FYRrcZUxk2uivwBX8j3qs4NzHXyTXiJ8vAW4jwsQWW57215tAVy+gaB
         dQEGPd9TDAANVz3UGOCGHlGa+sUBl8BeQQEeUpOylgn+/ScVw3HLLzDwJmW5KBJz6J2D
         oHv4WmXpWWzjUOZiegR5cF46pCFz9WqkduAoAwm81JD1qNOtaKp+y+icQQF8MJV1TgXj
         cUB3xJXt6jcTR0NjBetioKDiASPLDgIL4O1BngVJEsV9qyGtie4nGK0Cy9GWSnAbkU9i
         0r+g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230721054938.1666475-2-xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jul 21, 2023 at 01:49:38PM +0800, xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
> From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> 
> "listers" -> "listeners"
> 
> Signed-off-by: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>

Applied 1-2 to cgroup/for-6.6.

Thanks.

-- 
tejun
