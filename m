From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting for veth queues
Date: Thu, 28 Apr 2022 01:48:43 +0300
Message-ID: <9600b84a-8590-4e7b-c74d-3f52fe905e7f@openvz.org>
References: <1c338b99-8133-6126-2ff2-94a4d3f26451@openvz.org>
 <20220427095854.79554fab@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SQk+uPdXjus9l+tZCRcT7jspmYgklYtunIPDK1R0FPo=;
        b=4be664J+OKOeBO0o8b8/lSmk7jn8HmLIxoeRFfTKVZp/qfcuXsj0nn0H7AsnMzYhl1
         ES/5EofZCQG+lU25D5qAXkc8AWQpCGUfz9nDBy6CFgdN3kWmzPKWPX3ouImm0xjv8Hot
         Q1nLzcRXHoGKjZZq2Ugu0RFU8yN4C0APkgUeDUB6KrZ1trEszX9xLoTyIm2bJLDwMNdk
         N7W3FgisFjh7vg/mDxMWbdPH84tzDYTOBZqlPWxH+fPixhU1X26YGN658TZN77CaspzE
         6acX8xvHwftaEXxYqp5UMxc8oAGQBmwZm+vxqUqGmkQKqvGDa+d8noiqD3E455dFClQ1
         3Wlw==
Content-Language: en-US
In-Reply-To: <20220427095854.79554fab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 4/27/22 19:58, Jakub Kicinski wrote:
> On Wed, 27 Apr 2022 13:34:29 +0300 Vasily Averin wrote:
>> Subject: [PATCH] memcg: enable accounting for veth queues
> 
> This is a pure networking patch, right? The prefix should be "net: ",
> I think.
Thank you for the remark, I'll fix it.

Initially it was a part of the patch accounted resources accounted 
when creating a new netdevice, but then I moved this piece to
a separate patch, because unlike other cases, it is specific to veth.
 
Thank you,
	Vasily Averin
