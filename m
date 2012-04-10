From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Lsf] [RFC] writeback and cgroup
Date: Tue, 10 Apr 2012 11:23:16 -0500
Message-ID: <CAH2r5mvLVnM3Se5vBBsYzwaz5Ckp3i6SVnGp2T0XaGe9_u8YYA@mail.gmail.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120404145134.GC12676@redhat.com>
	<20120407080027.GA2584@quack.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=hl4OSVdFwlG//ki/U94GWUyphGzZfpEhM8olb5w3tqM=;
        b=HozFMFWMkQ2LvyR9wLK+OlaYWQTnwZ3TPZIbwQEE68Aa33exXocD/XaO7vwufh97vM
         JebFr3UJXSJl5V0kU8YHpC7b6Ggx2fP2WSfJ2dTZvhecZfZu+eDuqg5ecpmWk4DSjy8V
         rptmX3eP++6fMNyluf//umBv+lU6Hp33h1oTyGJLxuJwbqa4DvOh57FTddXyVZncCNLv
         Q+sAhCG2emfpN7JsMqdZSfSrRC9/ktrTt1+GSfU0t7qrWFKrT7LjaGrZO73MggfgZqd0
         SQzf/nMd3miENnPEttPYzpUe07bcVUtiLdktBpDf7/M0Jp38g8XgyGcM8n+ZoZLc9H0F
         Dq/A==
In-Reply-To: <20120407080027.GA2584-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lsf-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Apr 7, 2012 at 3:00 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> =A0Hi Vivek,
>
> On Wed 04-04-12 10:51:34, Vivek Goyal wrote:
>> On Tue, Apr 03, 2012 at 11:36:55AM -0700, Tejun Heo wrote:
>> [..]
>> > IIUC, without cgroup, the current writeback code works more or les=
s
>> > like this. =A0Throwing in cgroup doesn't really change the fundame=
ntal
>> > design. =A0Instead of a single pipe going down, we just have multi=
ple
>> > pipes to the same device, each of which should be treated separate=
ly.
>> > Of course, a spinning disk can't be divided that easily and their
>> > performance characteristics will be inter-dependent, but the place=
 to
>> > solve that problem is where the problem is, the block layer.
>>
>> How do you take care of thorottling IO to NFS case in this model? Cu=
rrent
>> throttling logic is tied to block device and in case of NFS, there i=
s no
>> block device.
> =A0Yeah, for throttling NFS or other network filesystems we'd have to=
 come
> up with some throttling mechanism at some other level. The problem wi=
th
> throttling at higher levels is that you have to somehow extract infor=
mation
> from lower levels about amount of work so I'm not completely certain =
now,
> where would be the right place. Possibly it also depends on the inten=
ded
> usecase - so far I don't know about any real user for this functional=
ity...

Remember to distinguish between the two ends of the network file system=
=2E
There are slightly different problems.   The client has to be able to
expose the number of requests (and size of writes, or equivalently
number of pages it can write at one time) so that writeback is not done
too aggressively.  File servers have to be able to
discover the i/o limits dynamically of the underlying volume (not the
block device, but potentially a pool of devices) so it can tell
the client how much i/o it can send.  For SMB2 server (Samba) and
eventually for NFS, how many simultaneous requests it
can support will allow them to sanely set the number of "credits"
on each response - ie tell the client how many requests
are allowed in flight to a particular export.

In the case of block device throttling - other than the file system
internally using such APIs who would use block device specific
throttling - only the file system knows where it wants to put hot data,
and in the case of btrfs, doesn't the file system manage the
storage pool.   The block device should be transparent to the
user in the long run, and only the volume visible.


--=20
Thanks,

Steve
