From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 3 Mar 2016 08:48:54 +0530
Message-ID: <CAG53R5WcbE8Hesb2sh6xg1fRLBOBt+VFo0L3U6WLPr3irtko8w@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
	<CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=3GYaJPzmwIIA5NjHN5Bix+PxCs8cowZ06lxWWFnZDZ8=;
        b=ClrP/PcUmEUHlnKbPqp0joUC1aUVbiLeqBkU9XxdItgZT91vSCKM66R5m5d9krv2mA
         8REyrHo+OGmdGehibhoo99Wbsr9QvDlmYPJ5PVk8BgGFn7XzuF5xYPAng94Fv2pEPYAw
         vop0ObfuYlNk7/5Gozs7xl/PkVd5gYn3yNL0EXHX0HjgUMoF521duvppx9rtx/IXHzTW
         BDxqhe5WVc5nsS2GapBgMPp06F/sjILApf09s/FcM/zw4wK9CaqXN+sMbG617fI03FxM
         cIjX7+sWIIId/8dDB7JXh/A2L625YTFxkaVj9XWMp+QUZiTqcNirMj0prfKsMnXF2jFF
         P61A==
In-Reply-To: <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 3, 2016 at 1:28 AM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Wed, Mar 2, 2016 at 11:09 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Nothing seems to prevent @cg from going away if this races with
>> @current being migrated to a different cgroup.  Have you run this with
>> lockdep and rcu debugging enabled?  This should have triggered a
>> warning.
I am able to reproduce this race. Looking into how to address it.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
