From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Cgroup hierarchical support
Date: Tue, 9 Jun 2015 13:24:23 +0900
Message-ID: <20150609042423.GP21465@mtj.duckdns.org>
References: <5575A5DA.7040507@kyup.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MTMwrMfVQhSZAcbIT/vYkdO+qJxvMoM4o+1+JL33KY4=;
        b=trV/fD6NKhwyZrQKRfepQxP5gYZbtoGp2kzdOqUCAv9Yequy0HlHx0huig7UibtESZ
         RMpF1c1Ne4GI4THPxP5p38m63vb1ES88f9MrpMEE9VwnaMFzNmDO7PfUHQTCvBQG2Ajs
         79kYwT/D+iGpyGN6vioLBvRu2tdPZznv8Tm8Xi9NsU0B+EpXp4onvAVMRuB0o8xt9Dac
         qONQ9uOhcXstn06nRn+zdKH1j+VHI98iFdIMfuOgq2xwLbH/AK0FyynrH55y8vikroK7
         b/2jYztzMU6OaiPFWOtG3+F5PdcCNVb/Q+K78S66rCSauGTPbX0LaaqfSSSmAx8cSK7d
         MjTw==
Content-Disposition: inline
In-Reply-To: <5575A5DA.7040507-6AxghH7DbtA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Nikolay.

On Mon, Jun 08, 2015 at 05:25:30PM +0300, Nikolay Borisov wrote:
> I'd like to ask which cgroup controllers actually support "hierarchical
> behavior". E.g. the children cgroups to be always bound by the limits of

All of them at this point, I think.

Thanks.

-- 
tejun
