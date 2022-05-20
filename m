From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Date: Fri, 20 May 2022 01:16:00 -1000
Message-ID: <Yod4cN+HayIDhR/c@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
 <YodCPWqZodr7Shnj@slm.duckdns.org>
 <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
 <20220520093607.sadvim2igfde6x22@apollo.legion>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cSj1iULxPa/Q17vQx9CvBh+XXwbDyu32iNxH8BDHGWo=;
        b=KAl6JiUblhGNLjQZ5H0XrsEH9sR+zAIGiIrYCvRSOx3z++Jx75Eil0AfqhCM8BbmPR
         qPbECuxldaypu17UE9fgu89sGfMl+EohW1msxEf6R+k1ZrxamBnRam6cYcJcx7mXGEqg
         g/6VIVWY73HuktEyJ9EyJCB4Lddi2viqjElMH2ai6Q9L+7nv7ma1iOTRAbMr0jGRP0sT
         T2ga5r8esXHAIG+CzKW2Pt1e8LuhbOIyKuceUi9Yu5OgSv+9+TSt7xFSfM1lI8rZhdxQ
         aVEFgCYfivV/FDw3ekn39hJpjJ8YmEZ/SpoeZdUduz+g+kLNR+zul2CDNo3FNVhbchS9
         tEIA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220520093607.sadvim2igfde6x22@apollo.legion>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev>

On Fri, May 20, 2022 at 03:06:07PM +0530, Kumar Kartikeya Dwivedi wrote:
> With static noinline, the compiler will optimize away the function. With global
> noinline, it can still optimize away the call site, but will keep the function
> definition, so attach works. Therefore __weak is needed to ensure call is still
> emitted. With GCC __attribute__((noipa)) might have been more appropritate, but
> LLVM doesn't support it, so __weak is the next best thing supported by both with
> the same side effect.

Ah, okay, so it's to prevent compiler from optimizing away call to a noop
function by telling it that we don't know what the function might eventually
be. Thanks for the explanation. Yosry, can you please add a comment
explaining what's going on?

Thanks.

-- 
tejun
