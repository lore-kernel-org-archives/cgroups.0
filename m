From: "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 22:29:21 +0800
Message-ID: <1679f995-5a6f-11b8-7870-54318db07d0d@gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz>
 <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook> <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
 <20210910092310.GA18084@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o86Ela2dKbz2GzHznXe/g7ScOOJeqlE0Zm5503NyBDQ=;
        b=Bxn804R0i4B8zYlx7gxgC59R+MuM6Dyg5UPT8+rmC10z0AGCD6J3RNEhD4t8PqcsUy
         XjMywQShlJsNUa+mJ9R3hTGfLxIvIo07GAicJZuvELS7AJouCi2m6hd1QT85YqLEVt3P
         XXQ9urfO7RBljpYSWvgX9x2iQRIUdVRgj0X77MuEt+hZ/M168SMbUg/Y5X/r+BBhbaSo
         V4w3Y1lCO9+JsoJHPpuhPazv6MIKsYMSV0vY+xb/4+r2sN927yPTM5HUm5qXYPk881E2
         dIWPDgI/Ph4IXh9dIIRKZ8jG0g/FhwDO8RHAg45Co+dMRiaSOo7umTTON+QCRPQJZ3Sq
         ZVcQ==
In-Reply-To: <20210910092310.GA18084-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for your time.

On 2021/9/10 5:23 PM, Michal Koutný wrote:
> On Fri, Sep 10, 2021 at 01:30:46PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> I am a bit confused here. For misc_cgroup, we can only be rejected when the count
>> touch Limit, but there may be other more reasons for other subsystems.
> 
> Sorry, I wasn't clear about that -- the failures I meant to be counted
> here were only the ones caused by (an ancestor) limit. Maybe there's a
> better naem for that.
> 
>> Therefore, when we are rejected, does it mean that we have touch
>> Limit? If so, do we still need to distinguish between max and fail?
>> (for misc_cgroup)
> 
> r
> `- c1
>     `- c2.max
>         `- c3
>            `- c4.max
> 	     `- task t
>            `- c5
> 
> Assuming c2.max < c4.max, when a task t calls try_charge and it fails
> because of c2.max, then the 'max' event is counted to c2 (telling that
> the limit is perhaps low) and the 'fail' event is counted to c4 (telling
> you where the troubles originated). That is my idea. Although in the
> case of short-lived cgroups, you'd likely only get the hierarchically
> aggregated 'fail' events from c3 or higher with lower (spatial)
> precision.
> What would be the type of information useful for your troubleshooting?

Through events and events.local, we can determine which node has 
insufficient resources. For example, when the ‘events’ is large, we 
traverse down and use events.local to determine which node has 
insufficient resources. 'fail' counter does not seem to provide more 
effective information in this regard. When 'fail' is big, it seems that 
we still need to use events and events.local to determine the node of 
insufficient resources. I am not very sure what details can we learn 
through 'fail' counter.

> 
> Cheers,
> Michal
> 
