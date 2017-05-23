From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 16:14:41 +0100
Message-ID: <2961.1495552481@warthog.procyon.org.uk>
References: <87zie3mxkc.fsf@xmission.com> <f167feeb-e653-12e3-eec8-24162f7f7c07@suse.de> <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk> <1495472039.2757.19.camel@HansenPartnership.com> <2446.1495551216@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 5E0904E35B
In-Reply-To: <87zie3mxkc.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-ID: <2960.1495552481.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:

> > As an example, I could set up a client machine with two ethernet ports,
> > set up two DNS+NFS servers, each of which think they're called "foo.bar"
> > and attach each server to a different port on the client machine.  Then I
> > could create a pair of containers on the client machine and route the
> > network in each container to a different port.  Now there's a problem
> > because the names of the cached DNS records for each port overlap.
> 
> Please look at ip netns add.

	warthog>man ip | grep setns
	warthog1>

> It does solve this in userspace rather simply.

Ummm...  How?  The kernel DNS resolver is not namespace aware.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
