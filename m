From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 0/7] memcg remove pre_destroy
Date: Mon, 16 Apr 2012 15:41:18 -0700
Message-ID: <20120416224118.GG12421@google.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ZF3Vkf1/v6cKQDLI6WSUcVnE3fXxY8bgF+wHse7WiFI=;
        b=hdXsZuJUSK57C6zmHUIAjTqBD3tt7q0+BEmz+pC3SeP4PhfsqtR3yN56qpdrBZzHm3
         hFKUrok1K6Y+KyHOxPhQ+EpxViGi7Cm/ibCzjeeynAi/Noxki2ZkqUCwY/dHBeFAzrnY
         WIXtGuBdWE5lhFWNa1IhBei3USbUMch+F7vpnNhU6Yy+SQsIfAIaxersLpyjHN20CzQk
         wjQ2M+hcP7hEsHz/dVhNie6KCwDTeIVShBbs+K/8xacaicd+h7osg0HnCi4sLKWuU80Y
         NR1PaO4Gd8bH0gB4LhqEQyPRLMkMX+IUovIWz7YVjTn6ZVFLrfLW/w1w3VzZYDpWEG0D
         IeKA==
Content-Disposition: inline
In-Reply-To: <4F86B9BE.8000105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, KAMEZAWA.

On Thu, Apr 12, 2012 at 08:17:18PM +0900, KAMEZAWA Hiroyuki wrote:
> In recent discussion, Tejun Heo, cgroup maintainer, has a plan to remove
> ->pre_destroy(). And now, in cgroup tree, pre_destroy() failure cause WARNING.

I did a pretty shallow review of the patchset and other than the
unnecessary async destruction, my complaints are mostly trivial.  Ooh,
and the patchset doesn't apply cleanly on top of cgroup/for-3.5.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.5

Thank you!

-- 
tejun
