From: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Subject: RE: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Thu, 17 Mar 2022 09:30:09 +0000
Message-ID: <943440a04e4c4731a3e9e6a7b1259251@saabgroup.com>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <YjIShE3mwRyNbO53@slm.duckdns.org>
 <e9cac4aba6384c5c91125a9f7d61a4e8@saabgroup.com>
 <YjIfMLG5W2a/E4vX@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 weald.air.saab.se 22H9UAHZ073375
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=saabgroup.com;
        s=weald; t=1647509411;
        bh=b6FqKrBh6NuQz0yvGHKXPjeDUeXTkFJrPXcooHJHzV4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=o6fXvX9Q0tncD/kN53hCHF4dU0FVKcL60NwupF1CCQ4PHXHkgT9sAhd4yjrxBOMIS
         F2Krn57chEGI77kPFaanrLUtBHlHjMIcmVOzypWKOyV+xohsewJ+MjVN/bYp09w6eA
         YzsqGugrhrBus9ylMNG3Er4YAxBtCBUH5N8nYg+Y=
In-Reply-To: <YjIfMLG5W2a/E4vX-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> Yeah, mostly curious from cgroup design POV. It'd be nice to support
> use cases like this well but we likely don't wanna twist anything
> for it.

Ok. I'll give you some more details. :)

The building block we are discussing here (running a VM where VMM and
virtual core threads are scheduled using different schedulers and thus
effectively on different cores) is a building block in a larger
context. The use cases I have provided so far are still valid and
needed.

What you run in the VM is the OS plus application of some embedded
multicore system where the target hardware is way less competent than
what you are running the VM on. It will most likely even be using a
different CPU architecture so you cross compile to for instance x86.

Now put this building block in a simulator where other parts of the
larger system are connected to this VM. This simulator is used to
train persons who operate the real system and it is important it's
behavior closely mimics the actual real system. For instance response
times from the embedded system may not be too fast nor to too slow.


> Yeah, deligation can be useful. However, given that the
> configuration would need some automation / scripting anyway, it
> shouldn't be too difficult to work around.

Think of it like this. IT department installs the OS of the Host and
sets up cgroup node where a user group controls access to a
subtree. Developers belonging to this group are then allowed to
configure cgroup using abstract names for the nodes in the tree. The
software running on the server uses these abstract names and does not
need to know how they are configured. This means that when the
software is deployed in a different setting where you want another
behavior you just need to reconfigure the cgroup without needing to
recompile the software. And by relying on cgroups you also get less
source code to maintain (and that you might get wrong).


> The thing is, to put different threads of a process into different
> cgroups, one has to know which threads are doing what, which is the
> same knowledge needed to configure per-thread attributes.

Well, you might also have generic rules like for VM named "foo" you
put the VMM thread in "foo-vmm" and virtual core threads in
"foo-vct01" through "foo-vctnn". The actual mapping of these cgroups
to physical cores might differ from server to server. And you might
also select different schedulers and so on depending on server
configuration and the intention with the software installation. For
instance CI-loops that run batches where real-time behavior (matching
elapsed wall clock time in the simulation to actual system) is not
that important and you can fast-forward the simulation as you are
interested in functional tests and so on. This mean that the actual
software does not need to worry about such things.


/John

