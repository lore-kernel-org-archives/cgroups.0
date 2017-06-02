From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] KEYS: Allow a live daemon in a namespace to service request_key upcalls
Date: Fri, 02 Jun 2017 17:14:00 +0100
Message-ID: <1856.1496420040@warthog.procyon.org.uk>
References: <1496418474.13822.6.camel@redhat.com> <1496239145.289295.994170312.57409998@webmail.messagingengine.com> <149616052408.10194.7774163568767478808.stgit@warthog.procyon.org.uk> <3412.1496242065@warthog.procyon.org.uk> <1496244979.313075.994296480.7C5735E8@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com D46197D4E7
In-Reply-To: <1496418474.13822.6.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-ID: <1855.1496420040.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Ideally we'd like to run the upcall in the same set of namespaces that
> the user process initiating the activity is running.

Unfortunately, that's not necessarily good enough.  A process could see, for
example, a mounted network fs that it can interact with that has a different
network namespace to the one in that the process is in.

This is an issue that the in-kernel AFS fs has a particular problem with
because there is a userspace management tool suite that uses AF_RXRPC sockets,
but calling socket() will open it in the calling process's namespace, not the
target filesystem's namespace.

I think we need some sort of pin that you can put in the namespace map that
says that for certain combinations of namespaces, you come to this pin and
service requests here, in the set of namespaces at this point.

David
