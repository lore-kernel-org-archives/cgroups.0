From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] misc_cgroup: use a counter to count the number of
 failures
Date: Wed, 8 Sep 2021 13:29:18 +0800
Message-ID: <49057879-92a9-958a-ac30-057ceabd1b7f@gmail.com>
References: <a09f381462b1ce9c506a22713b998e21b459f7e9.1628899295.git.brookxu@tencent.com>
 <20210824164423.GA11859@blackbody.suse.cz> <YSVDwc/1sEmXdOK9@slm.duckdns.org>
 <4ed67493-e595-e002-69f9-1f53662ba189@gmail.com>
 <20210826112954.GD4520@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iD9+GT39aksQJ8UeFhirJAMKV3nyN4Kl41ljs81BeAQ=;
        b=fmHJ9TCvMYR155Ey0xmhEA8+GUH+8RWGwTLNvNo3adb/G+kkdBQt003sNOw0RYlz1T
         WVueDkaHjh0B1wi+x9HoykljOypMHA1ERQU36MhnKhG4RmAaq7CEi4+qDJm2vREq+dHJ
         uJFyRsvCzaCMr+HUciciZBZx4imn7nWoLUou9pnFpt6ZllukebteZwuwqGM5zu0ciUM1
         4hc129eckFug/Kb8i1MtqlFser48H/AYemzCFeSsn0lKxidw8eeFCfabkmLavY0ZIoyq
         nApqxwo3s2+EAXfdHYKwNN+PkYtJ5Bjmq622ReanNBMFWFt/7yNiIM1++eVn7oPuGPIt
         vAmQ==
In-Reply-To: <20210826112954.GD4520-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all:

I have sentout misc_cgroup events and events.local related patches.
I want to make corresponding changes to pids cgroup by the way. Do
you think it is ok?

Thanks.
