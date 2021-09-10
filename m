From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 13:30:46 +0800
Message-ID: <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz>
 <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=svfX9vrckIXv0kIsXF1Q/PyrjfnFqdiB+uHxilhWrdk=;
        b=DsoWUPYLyH10u3d1eAgto4n9+YHgGmryBuTU6J0m9Yr7KuorWxHF2yxAWPKUxWBFHM
         x2B0+3RoLsmf4Jj6mHDxW6RC1/bQK5guVuS1QaaQKBD1y9R3+sCHpUtDlY0KKKb5qRXk
         9oCPVpqniclK+QjaiuLG09eiKHArJ/W09gn5lAQmxBI9XFyvxTuIfpXCiOrSP5OH/O4F
         +V5PJLkog8EB3Se7oyPLlA+cj3bU1M3btokG2h8wHLg18TVsFnZLXjta+HxezIrvEyoX
         B7r88e18ApPdRNg+nNWe7rtHd6SGZp4sVu71gz1iAc1CeQCl6031+5br9Z4URhuohdL8
         WLDA==
In-Reply-To: <YTpY0G3+IJYmGbdd@blackbook>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Thanks for your time.

Michal Koutný wrote on 2021/9/10 2:56 上午:
> On Thu, Sep 09, 2021 at 09:49:56AM -0700, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>> We are adding two files in this patch series, misc.events and
>> misc.events.local. I think "fail" should go in misc.events.local and
>> its name should be changed to "max".
> 
> I consider the max vs fail orthogonal to local vs hierarchical. I.e.
> both entries can be in both files:
> 
> (1) misc.events.local:max	number of times the cgroup's misc.max was hit
> (2) misc.events.local:fail	number of times operation failed in the cgroup
> (3) misc.events:max		number of times the cgroup's misc.max was hit in the subtree
> (4) misc.events:fail		number of times operation failed in the subtree
> 
> Is that too many? Admittedly, I assume (1) and (4) will be the more useful ones.
> However, I'm afraid overloading "max" as suggested might be (more)
> confusing. ('subtree' above := self or descendant)

I am a bit confused here. For misc_cgroup, we can only be rejected when the count
touch Limit, but there may be other more reasons for other subsystems. Therefore,
when we are rejected, does it mean that we have touch Limit? If so, do we still
need to distinguish between max and fail? (for misc_cgroup)

> Michal
> 
