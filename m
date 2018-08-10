From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 12:14:00 -0400
Message-ID: <20180810161400.GA627@thunk.org>
References: <20180810153902.GH21087@thunk.org>
 <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
 <28045.1533916438@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org;
         s=ef5046eb; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SML2hrdrnTP2GFsjV13UJ8h9GTZNMMCvlSxSz8mpmH8=; b=KAdgtBrTVdOTfYDs4aRsMefQVx
        vl6HiRbe/6yXPaJz1X13ExHgAY1gdOO3Sd0OgekX1yGQgDPPRCb9/IxZS2qrd8dfWPJ4rxFX6r0kn
        IEgaWjJ/7zmc/ldAGGqMxPFLkjs3btvKC3Ool3nUBWyuWXSk0neTZrdsbbxZmp6IcrR4=;
Content-Disposition: inline
In-Reply-To: <28045.1533916438@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, viro@zeniv.linux.org.uk, John Johansen <john.johansen@canonical.com>, Tejun Heo <tj@kernel.org>, selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>, Li Zefan <lizefan@huawei.com>, linux-api@vger.kernel.org, apparmor@lists.ubuntu.com, Casey Schaufler <casey@schaufler-ca.com>, fenghua.yu@intel.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers@google.com>, linux-security-module@vger.kernel.org, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, Stephen Smalley <sds@tycho.nsa.gov>, tomoyo-dev-en@lists.sourceforge.jp, cgroups@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <m>

On Fri, Aug 10, 2018 at 04:53:58PM +0100, David Howells wrote:
> Theodore Y. Ts'o <tytso@mit.edu> wrote:
> 
> > Even *with* file system support, there's no way today for the VFS to
> > keep track of whether a pathname resolution came through one
> > mountpoint or another, so I can't do something like this:
> 
> Ummm...  Isn't that encoded in the vfsmount pointer in struct path?

Well, yes, and we do use this as a hack to make read-only bind mounts
work.  But that's done as a special case, and it's for permissions
checking only.

The big problem is that there is single dentry cache object regardless
of which mount point was used to access it.  So that makes it
impossible to support case folding as a mount-pointism.

> 
> However, the case folding stuff - is that a superblockism of a mountpointism?

It's a superblock-ism.  As far as I know the *only* thing that we can
support as a mount-pointism is the ro flag, and that's handled as a
special case, and only if the original superblock was mounted
read/write.  ey That was my point; aside from the ro flag, we can't
support any other mount options as a per-mount point thing, so the
only thing we can do is to fail the mount if there are conflicting
mount options.  And I'm not really sure it helps the container use
case, since the whole point is they want their "guest" to be able to
blithely run "mount /dev/sda1 -o noxattr /mnt" and not worry about the
fact that in some other container, someone had run "mount /dev/sda1 -o
xattr /mnt".  But having the second mount fail because of conflicting
mount option breaks the illusion that containers are functionally as
rich as VM's.

So before you put in lots of work to support rejecting the attmpted
mount if the mount options conflict, are we sure people will actually
find this to be useful?  Because it's not only fsopen() work for you,
but each file system is going to have to implement new functions to
answer the question "are these mount options conflicting or not?".
Are we sure it's worth the effort?

					- Ted
