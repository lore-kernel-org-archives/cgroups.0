From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH net-next v2 1/4] cgroup: Add cgroup_get_from_fd
Date: Thu, 23 Jun 2016 17:11:46 -0400
Message-ID: <20160623211146.GJ3262@mtj.duckdns.org>
References: <1466630252-3822277-1-git-send-email-kafai@fb.com>
 <1466630252-3822277-2-git-send-email-kafai@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9Wnur4VW4bUfu/6lhYhf0voaxp4/pHb0VQ/qqp0ANPQ=;
        b=Z+LJ5U//w/kdPVLFGdmRuJKKbd890Vt6Px0O7P1v4zj7c3hMVxKJDkJmJHnsCMBafu
         W9yajcsXoILhoQqusHWEIBE2u9HN6QveXlf7VuM1t29JGt2RIgsjjteOL+NSTKVRaAAi
         daNmS+2pr001MerT1dmI9CyIcTtNkbAFntEF2AKYoKLfuIgUSQjSwRcyx0TIb3U8/5OU
         cOQN8AcOoyjLc/bj0V+7c9eGp6n+rVUm8lxgtKPKzah4AT5Lde0fbCDLSmsBDWLiCDUZ
         Nv9NcF7jwLBSNKplZT8mtJpBOe85utBRpHUoEhfJeA/c4EjpCTVHhwvhR8O0YBPK28KY
         Afvw==
Content-Disposition: inline
In-Reply-To: <1466630252-3822277-2-git-send-email-kafai@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin KaFai Lau <kafai@fb.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, Alexei Starovoitov <ast@fb.com>, Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com

On Wed, Jun 22, 2016 at 02:17:29PM -0700, Martin KaFai Lau wrote:
> Add a helper function to get a cgroup2 from a fd.  It will be
> stored in a bpf array (BPF_MAP_TYPE_CGROUP_ARRAY) which will
> be introduced in the later patch.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> Cc: Alexei Starovoitov <ast@fb.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Tejun Heo <tj@kernel.org>

 Acked-by: Tejun Heo <tj@kernel.org>

Please feel free to route this patch with the rest of the series.  If
it's preferable to apply this to the cgroup branch, please let me
know.

Thanks!

-- 
tejun
