From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for
 bpf map
Date: Thu, 18 Aug 2022 12:33:02 -1000
Message-ID: <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=YHQ4Wh5SK0V1LEg6WvbUjjafnUpUy0D2IL3Ade8VZXw=;
        b=Xa18u0tB7HMzsnmKGxkVoZCzL7kLgnVNbrEM/pnut+g3QuGlZU8T82rRYMT+uH7JX8
         mJ2vZoVMfZ7DeQ3N/hRq0QVoE0dHnDCC6jHkB69qMIcAnfLOTXLgyZGlTOdJ4eKUvXXw
         4flHnx5l6ko15DdAn6q2TkKoxgnP4dUxXLL/EG6Sv5XUar7vSGs83fHEjEds6EMZiGtz
         OUBPUoY96/cACPNVbxTxEcH679zbytL6ggf+FUTfKgSAuhsuxedQglqb7+rqBqR9FhJ4
         LY0s3HpL/nWX/J45KMRDwAi5O0M0gueWwTXP3KDbK6EUtSzFPD5Sdz9+niAgDzYC3gNx
         7x8Q==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Yv67MRQLPreR9GU5@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, songmuchun@bytedance.com, akpm@linux-foundation.org, lizefan.x@bytedance.com, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org

On Thu, Aug 18, 2022 at 12:20:33PM -1000, Tejun Heo wrote:
> We have the exact same problem for any resources which span multiple
> instances of a service including page cache, tmpfs instances and any other
> thing which can persist longer than procss life time. My current opinion is

To expand a bit more on this point, once we start including page cache and
tmpfs, we now get entangled with memory reclaim which then brings in IO and
not-yet-but-eventually CPU usage. Once you start splitting the tree like
you're suggesting here, all those will break down and now we have to worry
about how to split resource accounting and control for the same entities
across two split branches of the tree, which doesn't really make any sense.

So, we *really* don't wanna paint ourselves into that kind of a corner. This
is a dead-end. Please ditch it.

Thanks.

-- 
tejun
