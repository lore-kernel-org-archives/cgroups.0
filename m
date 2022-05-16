From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH bpf-next v2 0/7] bpf: rstat: cgroup hierarchical stats
Date: Mon, 16 May 2022 09:39:35 -1000
Message-ID: <YoKod9FdpAe0L5dz@slm.duckdns.org>
References: <20220515023504.1823463-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GYimId1+Z3hhnSt3/2nNJtZTsF0tDudFtRYq4c1fKfY=;
        b=R5Sk0i4/JyOhBJzBZp0K+RPNVt9HIka8OnOU+L2bHdV9YE2hWPmLIotmoiIZF8LZQz
         66O7qWnBam0wZ/0whB93uSJVskDVMvHpzgCU2Mx8msc5Tdd1Ol1iQWq3gefC+JCK1rmS
         b6ViDXxnzhTXexN/pWzDNBV6ZoSAOqS97ZXIxmbpSngi2n4HTDRElMO4v1s5YmxaX5tE
         dxzDcIhljQenRUkMeyc/GfyfFeHvaVGJQ29jhYz6zLccANx9a6u7kVXG0iaK2JShglMp
         C1PeVtT5MCq0I2hHMg+Xb3mcsgzvW9WWkeKUqVlBh306S+SLkBRla0iI3hrwd6u+vr4h
         otwQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220515023504.1823463-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org

Hello,

Looks good from cgroup side.

Thanks.

-- 
tejun
