From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 2/3] cgroup: add cgroup_all_get_from_[fd/file]()
Date: Mon, 10 Oct 2022 14:11:08 -1000
Message-ID: <Y0S0nFSyivpU4H0n@slm.duckdns.org>
References: <20221010235845.3379019-1-yosryahmed@google.com>
 <20221010235845.3379019-3-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3HeZ1MWqvHmFwkHFUYY7AasOkcoNUsKqjWhjxCGFgtU=;
        b=qWi1ZwygS7xPmJRW43G176yEDlsQ51unX4GoUg2ea83DXcnYeh+ABvZZD0bQDvQqbD
         7qfX7QOojDNPcnkYxdyfKLeDImoDuUKa+VadF7E/uB7iAEbn/4SZxNtDDvxpNYYTA7Ku
         NkXmrp1R3aEpN/Qww+km5hnZJL9C/NP2oqJJGeS7mEVXAp4kLCN47o+1Zp5bR2wkOxm0
         NzSsXLcoGvme91agEmgMNwYktA9b+ghTzGHz5zIOv3iWDA4rrzyChm3DDvHfI1PNJ94b
         3sQhtKQ8lIiU+0jUyndK7Rd/gu+2IR0mVBAEvzbU12RsexDpxJOxTAwx6TJsVpiSwiZq
         AIZA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221010235845.3379019-3-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

On Mon, Oct 10, 2022 at 11:58:44PM +0000, Yosry Ahmed wrote:
> Add cgroup_all_get_from_fd() and cgroup_all_get_from_file() that
> support both cgroup1 and cgroup2.

Looks generally good. How about cgroup_v1v2_ as the prefix?

Thanks.

-- 
tejun
