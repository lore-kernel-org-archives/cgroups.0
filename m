From: Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] selftests: cgroup: Add 'malloc' failures checks in
 test_memcontrol
Date: Tue, 28 Mar 2023 10:56:02 -0600
Message-ID: <e2d86dd7-16c0-3d08-a906-3c81c0905187@linuxfoundation.org>
References: <20230226131634.34366-1-ivan.orlov0322@gmail.com>
 <Y/zzVWJ5PHs5My6x@P9FQF9L96D>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680022563; x=1682614563;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQykbIASwaSOYckFPBEJVXD9EFhn71W8gTG9pE8tJ28=;
        b=QWR06jmFMbM35tLVtFQq3O9myToaGC9er1DxfnCBHTEDHmxan8RTCzSppq9DWOPTZT
         HLuhb+yzXciKn+JYUvugYFEeOkuB+PWz65UHJQPVZ7MpMwXCZdxsXsCAMQTl5bEBYmua
         Ctg48hqn1V/ZTGzdIf6s3Svpb5HEk3k8j+6B8=
Content-Language: en-US
In-Reply-To: <Y/zzVWJ5PHs5My6x@P9FQF9L96D>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <skhan-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

On 2/27/23 11:15, Roman Gushchin wrote:
> On Sun, Feb 26, 2023 at 04:16:33PM +0300, Ivan Orlov wrote:
>> There are several 'malloc' calls in test_memcontrol, which can be
>> unsuccessful. This patch will add 'malloc' failures checking to
>> give more details about test's fail reasons and avoid possible
>> undefined behavior during the future null dereference (like the
>> one in alloc_anon_50M_check_swap function).
>>
>> Signed-off-by: Ivan Orlov <ivan.orlov0322-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> 
> Thanks!

Thank you all. Applied to linux-kselftest next for Linux 6.4-rc1

thanks,
-- Shuah
