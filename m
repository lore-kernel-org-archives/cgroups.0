From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [OOPS] BUG_ON in cgroups on 4.4.0-rc5-next
Date: Mon, 21 Dec 2015 16:56:18 -0500
Message-ID: <20151221215618.GB25997@mtj.duckdns.org>
References: <BLUPR0301MB200140C023EB8C2B414F6B13D8E10@BLUPR0301MB2001.namprd03.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wDncIntMPoDUeZ/hvL+uzONIvJXKKBHjIr4OvATvwco=;
        b=rrimk78vXTHIuW1BGB5Vns0zKpVwRjY3ft1XkK6o61/vHRU751Z6VXMcGqT8/YE1y1
         9gInwfrrglZN5QCgj8GcTj1T99gK1jVXNp7mheBCbfDMEg+Y5khT9Nnn0JibL/9pN/5g
         Cu7TRTbL7ye1L2gKwYeIxuUozCuFZOY8SId9NmZlKMnd53rYYMK+TVu20qIq5jsZ3wwc
         tyqB5rt9/bKUdxWZoPepNxOhWa5lrB7B6U8YDg7y8kXCOMp+Trb5xL76GOu5AK8XEJf9
         3lzijdMHOYX4YORQ92rnTqGz692ZgPsJjryN58M3bC96euuraYwkR0+vrq9o3CNEyiYf
         q6kA==
Content-Disposition: inline
In-Reply-To: <BLUPR0301MB200140C023EB8C2B414F6B13D8E10-1/ziRz4NpW1pnNF7ophFSpwN6zqB+hSMnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Alex Ng (LIS)" <alexng-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Alex.

On Fri, Dec 18, 2015 at 08:08:03PM +0000, Alex Ng (LIS) wrote:
> Hi,
> 
> I was running a "git clone" of the linux-next source tree and hit the following BUG_ON condition. My box is running kernel 4.4.0-rc5-next-20151217-52.27. Any ideas on how to pin down the cause?
> 
> The trace indicates that the following condition in compare_css_sets() triggered the oops:

Can you please let me know the steps to reproduce the bug?

Thanks.

-- 
tejun
