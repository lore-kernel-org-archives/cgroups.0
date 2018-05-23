From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH] [RFC] bpf: tracing: new helper bpf_get_current_cgroup_ino
Date: Tue, 22 May 2018 20:35:51 -0700
Message-ID: <20180523033550.z3tqo4lhd3zrmtdu@ast-mbp>
References: <20180513173318.21680-1-alban@kinvolk.io>
 <20180521162609.lpdrnozowmzdn57m@ast-mbp.dhcp.thefacebook.com>
 <CAH3MdRWgruVq+3r+2pHTah-c2zTO03vPkepjWDZ0_KrYcroy9A@mail.gmail.com>
 <CAH3MdRVdfw52atavT3KL8MpPw7zDM_hR6aUcqDP1PogLn_sH+w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=j5adTP+z8Uog94l9IbCZ1avIPlhL7kGo0u+Bkyvsc2E=;
        b=eSkgzyemPMJ27u/Vh4i6H2YmfF1HMgptGrAEJZQ92BPuIKdHE2MSQBOCRRQeoop8MB
         h3LVnDmb5N0W0CvP+PD88tnG7Niz5fCoa8O6g1bGacuT693KPUYT8YLG3QGE8r/qPozw
         V7gABs6k5rLGUeIiTCl7+oHin7EaCY3hVGTiktT4i70bm/J8CAXptNNjt1Lc7PWH7M3s
         dZBaDFd5a2LKJdZPvNRMGxHXkNNJBW7q+jMP2cM/R9KjmjlD8me/6BTxl2BWez8+WPQI
         Cdq60UQi8HKZZF4GGeHxElJ57fUG48I6o8yPnLxjBktY7PV6wZ0BJbrbP7fqK+ZYRPMP
         N6TA==
Content-Disposition: inline
In-Reply-To: <CAH3MdRVdfw52atavT3KL8MpPw7zDM_hR6aUcqDP1PogLn_sH+w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Y Song <ys114321@gmail.com>
Cc: Alban Crequy <alban.crequy@gmail.com>, netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, Alban Crequy <alban@kinvolk.io>, tj@kernel.org

On Tue, May 22, 2018 at 08:33:24PM -0700, Y Song wrote:
> +       struct cgroup *cgrp = task_dfl_cgroup(current);
> +       if (!cgrp)
> +               return -EINVAL;

why this check is needed?

