From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH -next 2/4] cgroup: bpf: Add BPF_MAP_TYPE_CGROUP_ARRAY
Date: Tue, 21 Jun 2016 18:15:57 -0700
Message-ID: <20160622011555.GB97149@ast-mbp.thefacebook.com>
References: <1466555002-1316296-1-git-send-email-kafai@fb.com>
 <1466555002-1316296-3-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ic5jmGTJOZikpo4mTyQxVXgRMALGUZPfEJuGUZ7ElI0=;
        b=uvGAAacw823ledJGC2+TuVLEerCL2H6CC1/Z2bnwemYKD7rAAY7zA8UUWPN+stkH6J
         chlGYCieXaUxGLAmef/f9uTgjJZX25fQTcxsZwijB3/4pnHPKaAPTeuihv01u9zHGFd8
         cEwT+Xr7YJHZtHaWl7cLsVu0vQUznvhJOtdLyaOJ1q2jDIeYY5NFV3rS0Ads3HYrvGhP
         WQGdOaErwlGNAxnBEQgCJo2o9/3hUSWNEupHhIciw1igpdiCoI2rtVWyEofsVWbIVOhD
         D5Tkb8Asw4gQnMZ/hPc5C1cMN+6H6MxatWzbP7/7XmwMe9YRkMESDSYiF6op/x9BgMIV
         oqYA==
Content-Disposition: inline
In-Reply-To: <1466555002-1316296-3-git-send-email-kafai@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin KaFai Lau <kafai@fb.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com

On Tue, Jun 21, 2016 at 05:23:20PM -0700, Martin KaFai Lau wrote:
> Add a BPF_MAP_TYPE_CGROUP_ARRAY and its bpf_map_ops's implementations.
> To update an element, the caller is expected to obtain a cgroup2 backed
> fd by open(cgroup2_dir) and then update the array with that fd.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> Cc: Alexei Starovoitov <ast@fb.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Tejun Heo <tj@kernel.org>

Acked-by: Alexei Starovoitov <ast@kernel.org>
