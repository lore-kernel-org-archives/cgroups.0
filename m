From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-5.5] kernfs,cgroup: support 64bit inos and
 unify cgroup IDs
Date: Thu, 7 Nov 2019 07:31:11 -0800
Message-ID: <20191107153111.GV3622521@devbig004.ftw2.facebook.com>
References: <20191104235944.3470866-1-tj@kernel.org>
 <CAM9d7cjXX8aYYjJdnb0SUjBYwhOTWiD+V9fagUVnW9FUS6C=5g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OYN7vTt8Jizl5Ja6H+vm2wVj9xnVEWWh3pARe128MqA=;
        b=iPfpPMToSIjqAEneusgPnKkHTUg6LPqBJlhPxItj8EG/jn2j67b6Kk1F9579naxQcw
         oX203Nuq/Gsb0gE9fnkb6QIjcBobHuQ9YpKKO58m9rSoZgyQ+g8xQ3YqDop5AyN5yLrU
         hBGDiUkEc+2jOdiXGLuiJ0sKZhTdhpVjy+GaPmV1fVClwsXDfoMk7GWDyRpgDR3oMRNX
         r6bObgN0SXCsPwtjRfyy4bwD48VmqrvZZvcuVO12iRfHGWbGGIJfPc3YkRe9JBzPFLal
         7vNl5PNwiXH7m48XSgJSSBG2nQiQksAd2VX561TBE2V3VWSTxmh7RckF4OHGgiL0NnbU
         Py/w==
Content-Disposition: inline
In-Reply-To: <CAM9d7cjXX8aYYjJdnb0SUjBYwhOTWiD+V9fagUVnW9FUS6C=5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-team@fb.com, linux-kernel <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>

On Wed, Nov 06, 2019 at 10:50:15PM +0900, Namhyung Kim wrote:
> Thanks a lot for doing this!  I've tested it with my perf cgroup patchset
> based on top of this series and it looks good.  You can add my
> 
> Tested-by: Namhyung Kim <namhyung@kernel.org>

Thanks for testing, sorry about the delay!

-- 
tejun
