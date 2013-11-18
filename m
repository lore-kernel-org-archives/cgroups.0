From: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Mon, 18 Nov 2013 15:31:26 +0100
Message-ID: <CA+SBX_PqdsG5LBQ1uLpPsSUsbjF8TJ+ok4E+Hp_3AdHf+_5e-A@mail.gmail.com>
References: <5277932C.40400@huawei.com>
	<CA+SBX_ORkOzDynKKweg=JomY2+1kz4=FXYJXYMsN8LKf48idBg@mail.gmail.com>
	<5278B3F1.9040502@huawei.com>
	<20131107235301.GB1092@cmpxchg.org>
	<20131108001437.GC1092@cmpxchg.org>
	<CA+SBX_P6wzmb0k0qM1m06C_1024ZTfYZOs0axLBBJm46X+osqA@mail.gmail.com>
	<20131111153943.GA22384@dhcp22.suse.cz>
	<CA+SBX_PiRoL7HU-C_wXHjHYduYrbTjO3i6_OoHOJ_Mq+sMZStg@mail.gmail.com>
	<20131112135844.GA6049@dhcp22.suse.cz>
	<CA+SBX_O4oK1H7Gtb5OFYSn_W3Gz+d-YqF7OmM3mOrRTp6x3pvw@mail.gmail.com>
	<20131118094554.GA32623@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=x0MQuqjmaVHnOttLfU6+59MDjsn3r/zk7473tmTM1oY=;
        b=nNCvjTzZSfqzUiwVOtwEvB1bN9wfNEy5gPA0mseri8t/Ww1wY6+ODQ+bcRp+pdzJdX
         uZ7odAAGJHupdJUbGD0k3fEBS504Hcs3eZZ3BWDtYIKv1xbUYdSdigi9V5erNeFe5/5G
         n53Q+Lthx3o6LHO5h5bBu5Bh2RVA7GKkiwCQAQdbdew8YzX17CUFn14slEgaKfZ6iCRH
         /LUhfARUdBpWbPxU0W1U/dN/CGOHMVZOKn5bfFa44DorMR+npnW0Ch0NFcxfoGw7F1Zf
         iDXSbDiqSnqcnKWQ3Xyuy0eiR1Z/5t9s430Kxti4ZXIGDnIJf1C29ELAzroV3XEtpmZ5
         Xl6g==
In-Reply-To: <20131118094554.GA32623-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> There is one more issue which is discussed in another thread
> (https://lkml.org/lkml/2013/11/15/31) and Tejun has posted a patch (and
> Hugh followed up on it https://lkml.org/lkml/2013/11/17/166) to fix
> the cgroup destruction path which may get stuck.
>

Tried out the patches from Johannes, Tejun+Hugh and Michal all
together and my problem still persists :-(
Anything I can try besides bisectioning (which I still could not get
to work yet)?
