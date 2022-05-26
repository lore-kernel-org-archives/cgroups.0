From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Thu, 26 May 2022 11:56:34 +0200
Message-ID: <Yo7KfEOz92kS2z5Y@blackbook>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653558995; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFhmgixX5LOgkqqC8+umKFYLrjndJW5kicXnZWzhHcM=;
        b=IFtKrgBpUSxaIqVCvIEJxuP0+8BajYar9PUK+it7szWAOhxuqgh3gsI50vxQ5v2+PAk+v5
        HmhTw77kSpoGw0/3EJ8WyMbDUAVjADlDKKvwZcwDnjw6FA5moc+3dGsd+gFfKPR7xHm1RT
        FKNfMRfPE3vE2jk8xlz9H4AnRMv+oTs=
Content-Disposition: inline
In-Reply-To: <20220525161455.GA16134-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

On Wed, May 25, 2022 at 06:14:55PM +0200, Michal Koutn=FD <mkoutny-IBi9RG/b=
67k@public.gmane.org> wrote:
> But the above is not correct. I've looked at the stack trace [1] and the
> offending percpu_ref_put_many is called from an RCU callback
> percpu_ref_switch_to_atomic_rcu(), so I can't actually see why it drops
> to zero there...

The link [1] should have been [1].
After some more thought, the following is possible sequencing of
involved functions.

// ref=3DA: initial state
kill_css()
  css_get // ref+=3DF =3D=3D A+F: fuse
  percpu_ref_kill_and_confirm
    __percpu_ref_switch_to_atomic
      percpu_ref_get
        // ref +=3D 1 =3D=3D A+F+1: atomic mode, self-protection
    percpu_ref_put
      // ref -=3D 1 =3D=3D A+F: kill the base reference
  [via rcu]
  percpu_ref_switch_to_atomic_rcu
    percpu_ref_call_confirm_rcu
      css_killed_ref_fn =3D=3D refcnt.confirm_switch
        queue_work(css->destroy_work)        (1)
                                                     [via css->destroy_work]
                                                     css_killed_work_fn =3D=
=3D wq.func
                                                       offline_css() // nee=
ds fuse
                                                       css_put // ref -=3D =
F =3D=3D A: de-fuse
      percpu_ref_put
        // ref -=3D 1 =3D=3D A-1: remove self-protection
        css_release                                   // A <=3D 1 -> 2nd qu=
eue_work explodes!
          queue_work(css->destroy_work)      (2)
          [via css->destroy_work]
          css_release_work_fn =3D=3D wq.func

Another CPU would have to dispatch and run the css_killed_work_fn
callback in parallel to percpu_ref_switch_to_atomic_rcu. It's a more
correct explanation, however, its likelihood does seem very low. Perhaps
some debug prints of percpu_ref_data.data in percpu_ref_call_confirm_rcu
could shed more light onto this [2].

HTH,
Michal

[1] https://syzkaller.appspot.com/text?tag=3DCrashReport&x=3D162b5781f00000
[2] I tried notifying syzbot about [3] moments ago.
[3] https://github.com/Werkov/linux/tree/cgroup-ml/css-lifecycle-syzbot

