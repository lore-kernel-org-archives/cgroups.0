From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Wed, 18 Jan 2012 13:36:38 -0800
Message-ID: <20120118213638.GA21533@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
 <20120117175322.GC6762@google.com>
 <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=l3pXxW0sCkLP0A7K8drBV08saxYp7JXKJw4UFDJ5IMk=;
        b=cqKnJtUjI/IC+k7/QHCVCC00P/BxpogldEDJOZnKZ5wo3MqZ/yqycfRrLitP4WHGwZ
         doc7uHRpi60twGxlmkCxk9jugpyi9dtZrpOTcxQFshb6cQmfakZoknGjILSUmz+pseqM
         GNtjUrPzYEa95uuNKO6rKWuMy+foHbS7ZS4R4=
Content-Disposition: inline
In-Reply-To: <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hello,

On Wed, Jan 18, 2012 at 10:28:42PM +0100, Kay Sievers wrote:
> The idea with the cgroup fs xattrs was to be able to attach some
> general useful attributes to the 'service container' itself, instead
> of keeping them in the memory of the managing process or store them on
> disk which can get out-of-sync much easier.

Hmmm.... I can see the attraction but there really is nothing which
binds that information to cgroup.  The same information might as well
live in /proc/PID/userland_data or whatever.  It may be convenient now
but I'm pretty skeptical it's a good idea in the long run.

Given that cgroups themselves need to be explicitly created and
destroyed, maintaining a parallel tmpfs hierarchy for metadata, if
necessary, shouldn't be too bothersome, right?

Thanks.

-- 
tejun
