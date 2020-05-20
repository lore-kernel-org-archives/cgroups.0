From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v4 2/4] mm: move penalty delay clamping out of calculate_high_delay()
Date: Tue, 19 May 2020 18:40:19 -0700
Message-ID: <CALvZod7UNtiebGvsB6tPXCBPZ0vFjreJ7LwyM=D5LdFpAh9Jfg@mail.gmail.com>
References: <20200519171938.3569605-1-kuba@kernel.org> <20200519171938.3569605-3-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AB3UrpKdSYqNoKld+7/yBXeix6D5EW8de7N53rttU58=;
        b=ZUbKC5RNgCvyOLKPhsbIJ57dk4je8Jxm8s6LskPkh9P6Xf0Gw5nSczmWdhwSu4jd27
         CwTWLhpkwuskeAVzCFYT9z1qB3DX9iXCCx2xazjxq9DBsjXCSbrBiUP5c9xBuRgw8KSt
         N/yUCpmbRIKBOsVPAIEBjZgL6DVOnCqsrspO3TSfpZEU32dF4FZv1GRdPw0C2bvIqonN
         jV3kRZrJoV+9+nIz9nbL8s8jvHGS3ZzZ2V1LuzGp0LDxKHGhXP+g6dzVa94utIFjlAxC
         V3ZXsHx4ZJWlmIJqT1gUZgQCnyi19eL65wL4H1n7HyQ48/X/m87Ko+zlz2hx/DOBfq2U
         Yu/w==
In-Reply-To: <20200519171938.3569605-3-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, May 19, 2020 at 10:19 AM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> We will want to call calculate_high_delay() twice - once for
> memory and once for swap, and we should apply the clamp value
> to sum of the penalties. Clamping has to be applied outside
> of calculate_high_delay().
>
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
